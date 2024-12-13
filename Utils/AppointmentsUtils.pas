unit AppointmentsUtils;

interface

uses AppointmentUnit, System.SysUtils;

function AppointmentStatusToString(Status: TAppointmentStatus): string;
function StringToAppointmentStatus(StatusString: string): TAppointmentStatus;

implementation

function AppointmentStatusToString(Status: TAppointmentStatus): string;
begin
  case Status of
    Pending: Result := 'Pending';
    Confirming: Result := 'Confirming';
    Confirmed: Result := 'Confirmed';
    NotConfirmed: Result := 'Not Confirmed';
    Cancelled: Result := 'Cancelled';
    Completed: Result := 'Completed';
  else
    Result := 'UnKnown';
  end;
end;

function StringToAppointmentStatus(StatusString: string): TAppointmentStatus;
begin
  if StatusString = 'Pending' then
    Result := Pending
  else if StatusString = 'Confirming' then
    Result := Confirming
  else if StatusString = 'Confirmed' then
    Result := Confirmed
  else if StatusString = 'Not Confirmed' then
    Result := NotConfirmed
  else if StatusString = 'Cancelled' then
    Result := Cancelled
  else if StatusString = 'Completed' then
    Result := Completed
  else
    raise Exception.CreateFmt('Unknown appointment status: %s', [StatusString]);
end;

end.
