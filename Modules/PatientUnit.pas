unit PatientUnit;

interface

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
    constructor Create(
      APatientID: Integer;
      AFirstName: string;
      ALastName: string;
      APhoneNumber: string;
      AAddress: string;
      ADateOfBirth: TDateTime;
      AEmail: string
    );

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

constructor TPatient.Create(APatientID: Integer; AFirstName: string; ALastName: string; APhoneNumber: string; AAddress: string; ADateOfBirth: TDateTime; AEmail: string);
begin
  FPatientID := APatientID;
  FFirstName := AFirstName;
  FLastName := ALastName;
  FPhoneNumber := APhoneNumber;
  FAddress := AAddress;
  FDateOfBirth := ADateOfBirth;
  FEmail := AEmail
end;

function TPatient.GetFullName: string;
begin
  Result := FFirstName + ' ' + FLastName;
end;

end.
