unit PatientUnit;

interface

uses
  System.SysUtils, ValidationUtils;

type
  TPatient = class
  private
    FPatientID: Integer;
    FFirstName: string;
    FLastName: string;
    FPhoneNumber: string;
    FAddress: string;
    FDateOfBirth: TDateTime;
    FEmail: string;
  public
    constructor Create; overload;
    constructor Create(
      APatientID: Integer;
      const
      AFirstName,
      ALastName,
      APhoneNumber,
      AAddress,
      AEmail: string;
      ADateOfBirth: TDateTime
    ); overload;

    function GetFullName: string;

    property PatientID: Integer read FPatientID write FPatientID;
    property FirstName: string read FFirstName write FFirstName;
    property LastName: string read FLastName write FLastName;
    property PhoneNumber: string read FPhoneNumber write FPhoneNumber;
    property Address: string read FAddress write FAddress;
    property DateOfBirth: TDateTime read FDateOfBirth write FDateOfBirth;
    property Email: string read FEmail write FEmail;
  end;

implementation

constructor TPatient.Create;
begin
  inherited Create;
  FPatientID := -1;
  FFirstName := '';
  FLastName := '';
  FPhoneNumber := '';
  FAddress := '';
  FEmail := '';
  FDateOfBirth := 0;
end;

constructor TPatient.Create(APatientID: Integer; const AFirstName, ALastName, APhoneNumber, AAddress, AEmail: string; ADateOfBirth: TDateTime);
begin
  if APatientID <= 0 then
    raise Exception.Create('Invalid Patient ID.');
  if AFirstName.Trim.IsEmpty or ALastName.Trim.IsEmpty then
    raise Exception.Create('First name and last name cannot be empty.');
  if not IsValidEmail(AEmail) then
    raise Exception.Create('Invalid email format.');
  if not IsValidPhoneNumber(APhoneNumber) then
    raise Exception.Create('Invalid phone number.');

  FPatientID := APatientID;
  FFirstName := AFirstName;
  FLastName := ALastName;
  FPhoneNumber := APhoneNumber;
  FAddress := AAddress;
  FEmail := AEmail;
  FDateOfBirth := ADateOfBirth;
end;

function TPatient.GetFullName: string;
begin
  Result := FFirstName + ' ' + FLastName;
end;

end.
