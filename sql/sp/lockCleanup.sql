/** stored procedure for dana_lupo project
 * @author christophersecord
 * @date 20130319
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_lockCleanup;

DELIMITER //

/** lockCleanup
 * deletes timed-out locks. Truncates the table (for performance reasons) if no valid locks remain
 */
create procedure dl_lockCleanup()
begin

  -- this temp table to hold lockIDs is necessary to avoid MySQL error 1093
  create temporary table lockIDs (
    lockID int not null primary key
  );

  insert lockIDs (lockID)
  select lockID
  from dl_appointmentLock, dl_config
  where
    varName = 'apt_lock_time'
    and (
      -- delete locks older than 'apt_lock_time' minutes
      hour(timeDiff(now(),bookedOn))*60 + minute(timeDiff(now(),bookedOn)) > intVal
      -- delete locks older than a day
      or dateDiff(now(),bookedOn) > 1
    );

  -- I'm not sure why the delete statement below triggers the safe update error, since it uses a key column
  SET SQL_SAFE_UPDATES=0;

  delete
  from dl_appointmentLock
  where lockID in (
    select lockID
    from lockIDs
  );

  -- truncate table if it's empty
/*
  if not exists (
    select * from dl_appointmentLock
  ) then
  
    truncate dl_appointmentLock;

  end if;
*/
  drop table lockIDs;
end //