// Copyright 2023 Greptime Team
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

use std::fmt::Display;

use bytes::{Buf, BufMut};
use common_time::interval::IntervalFormat;
use common_time::{IntervalDayTime, IntervalMonthDayNano, IntervalYearMonth};
use pgwire::types::ToSqlText;
use postgres_types::{to_sql_checked, FromSql, IsNull, ToSql, Type};

#[derive(Debug, Clone, Copy, Default)]
pub struct PgInterval {
    pub(crate) months: i32,
    pub(crate) days: i32,
    pub(crate) microseconds: i64,
}

impl From<IntervalYearMonth> for PgInterval {
    fn from(interval: IntervalYearMonth) -> Self {
        Self {
            months: interval.months,
            days: 0,
            microseconds: 0,
        }
    }
}

impl From<IntervalDayTime> for PgInterval {
    fn from(interval: IntervalDayTime) -> Self {
        Self {
            months: 0,
            days: interval.days,
            microseconds: interval.milliseconds as i64 * 1000,
        }
    }
}

impl From<IntervalMonthDayNano> for PgInterval {
    fn from(interval: IntervalMonthDayNano) -> Self {
        Self {
            months: interval.months,
            days: interval.days,
            microseconds: interval.nanoseconds / 1000,
        }
    }
}

impl From<PgInterval> for IntervalMonthDayNano {
    fn from(interval: PgInterval) -> Self {
        IntervalMonthDayNano::new(
            interval.months,
            interval.days,
            // Maybe overflow, but most scenarios ok.
            interval.microseconds.checked_mul(1000).unwrap_or_else(|| {
                if interval.microseconds.is_negative() {
                    i64::MIN
                } else {
                    i64::MAX
                }
            }),
        )
    }
}

impl Display for PgInterval {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{}",
            IntervalFormat::from(IntervalMonthDayNano::from(*self)).to_postgres_string()
        )
    }
}

impl ToSql for PgInterval {
    to_sql_checked!();

    fn to_sql(
        &self,
        _: &Type,
        out: &mut bytes::BytesMut,
    ) -> std::result::Result<postgres_types::IsNull, Box<dyn snafu::Error + Sync + Send>>
    where
        Self: Sized,
    {
        // https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/timestamp.c#L989-L991
        out.put_i64(self.microseconds);
        out.put_i32(self.days);
        out.put_i32(self.months);
        Ok(postgres_types::IsNull::No)
    }

    fn accepts(ty: &Type) -> bool
    where
        Self: Sized,
    {
        matches!(ty, &Type::INTERVAL)
    }
}

impl<'a> FromSql<'a> for PgInterval {
    fn from_sql(
        _: &Type,
        mut raw: &'a [u8],
    ) -> std::result::Result<Self, Box<dyn snafu::Error + Sync + Send>> {
        // https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/timestamp.c#L1007-L1010
        let microseconds = raw.get_i64();
        let days = raw.get_i32();
        let months = raw.get_i32();
        Ok(PgInterval {
            months,
            days,
            microseconds,
        })
    }

    fn accepts(ty: &Type) -> bool {
        matches!(ty, &Type::INTERVAL)
    }
}

impl ToSqlText for PgInterval {
    fn to_sql_text(
        &self,
        ty: &Type,
        out: &mut bytes::BytesMut,
    ) -> std::result::Result<postgres_types::IsNull, Box<dyn snafu::Error + Sync + Send>>
    where
        Self: Sized,
    {
        let fmt = match ty {
            &Type::INTERVAL => self.to_string(),
            _ => return Err("unsupported type".into()),
        };

        out.put_slice(fmt.as_bytes());
        Ok(IsNull::No)
    }
}
