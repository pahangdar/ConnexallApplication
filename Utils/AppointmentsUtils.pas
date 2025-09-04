unit AppointmentsUtils;

interface

uses AppointmentUnit, System.SysUtils, TypInfo;

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
//  Result := GetEnumName(TypeInfo(TAppointmentStatus), Ord(Status));
end;

function StringToAppointmentStatus(StatusString: string): TAppointmentStatus;
var
//  Value: Integer;
  CheckString: string;
begin
  CheckString := Trim(StatusString);
  if CheckString = 'Pending' then
    Result := asPending
  else if CheckString = 'Confirming' then
    Result := asConfirming
  else if CheckString = 'Confirmed' then
    Result := asConfirmed
  else if CheckString = 'Not Confirmed' then
    Result := asNotConfirmed
  else if CheckString = 'Cancelled' then
    Result := asCancelled
  else if CheckString = 'Completed' then
    Result := asCompleted
  else
    raise Exception.CreateFmt('Unknown appointment status: %s', [CheckString]);
//  CheckString := 'as' + Trim(StatusString);
//  Value := GetEnumValue(TypeInfo(TAppointmentStatus), CheckString);
//  if Value < 0 then
//    raise Exception.CreateFmt('Unknown appointment status: %s', [StatusString]);
//
//  Result := TAppointmentStatus(Value);
end;

end.
