unit DoctorUnit;

interface

uses
  System.SysUtils, ValidationUtils;

type
  TDoctor = class
  private
    FDoctorID: Integer;
    FFirstName: string;
    FLastName: string;
    FSpecialization: string;
    FPhoneNumber: string;
    FEmail: string;
  public
    constructor Create; overload;
    constructor Create(
      ADoctorID: Integer;
      const
      AFirstName,
      ALastName,
      ASpecialization,
      APhoneNumber,
      AEmail: string
    ); overload;

    function GetFullName: string;

    property DoctorID: Integer read FDoctorId write FDoctorId;
    property FirstName: string read FFirstName write FFirstName;
    property LastName: string read FLastName write FLastName;
    property Specialization: string read FSpecialization write FSpecialization;
    property PhoneNumber: string read FPhoneNumber write FPhoneNumber;
    property Email: string read FEmail write FEmail;
  end;

implementation

constructor TDoctor.Create;
begin
  inherited Create;
  FDoctorID := -1;
  FFirstName := '';
  FLastName := '';
  FSpecialization := '';
  FPhoneNumber := '';
  FEmail := '';
end;

constructor TDoctor.Create(ADoctorID: Integer;const AFirstName, ALastName, ASpecialization, APhoneNumber, AEmail: string);
begin
    if ADoctorID <= 0 then
    raise Exception.Create('Invalid Doctor ID.');
  if AFirstName.Trim.IsEmpty or ALastName.Trim.IsEmpty then
    raise Exception.Create('First name and last name cannot be empty.');
  if not IsValidEmail(AEmail) then
    raise Exception.Create('Invalid email format.');
  if not IsValidPhoneNumber(APhoneNumber) then
    raise Exception.Create('Invalid phone number.');

  FDoctorID := ADoctorID;
  FFirstName := AFirstName;
  FLastName := ALastName;
  FSpecialization := ASpecialization;
  FPhoneNumber := APhoneNumber;
  FEmail := AEmail;
end;

function TDoctor.GetFullName: string;
begin
  Result := FFirstName + ' ' + FLastName;
end;

end.
