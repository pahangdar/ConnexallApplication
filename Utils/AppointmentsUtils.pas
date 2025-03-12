unit AppointmentsUtils;

interface

uses AppointmentUnit, System.SysUtils;

function AppointmentStatusToString(Status: TAppointmentStatus): string;
function StringToAppointmentStatus(StatusString: string): TAppointmentStatus;
function IsValidStatus(AStatus: TAppointmentStatus): Boolean;

implementation

function IsValidStatus(AStatus: TAppointmentStatus): Boolean;
begin
  Result := AStatus in [asPending, asConfirming, asConfirmed, asNotConfirmed, asCancelled, asCompleted];
end;

function AppointmentStatusToString(Status: TAppointmentStatus): string;
begin
  case Status of
    asPending: Result := 'Pending';
    asConfirming: Result := 'Confirming';
    asConfirmed: Result := 'Confirmed';
    asNotConfirmed: Result := 'Not Confirmed';
    asCancelled: Result := 'Cancelled';
    asCompleted: Result := 'Completed';
  else
    Result := 'UnKnown';
  end;
end;

function StringToAppointmentStatus(StatusString: string): TAppointmentStatus;
begin
  if StatusString = 'Pending' then
    Result := asPending
  else if StatusString = 'Confirming' then
    Result := asConfirming
  else if StatusString = 'Confirmed' then
    Result := asConfirmed
  else if StatusString = 'Not Confirmed' then
    Result := asNotConfirmed
  else if StatusString = 'Cancelled' then
    Result := asCancelled
  else if StatusString = 'Completed' then
    Result := asCompleted
  else
    raise Exception.CreateFmt('Unknown appointment status: %s', [StatusString]);
end;

end.
