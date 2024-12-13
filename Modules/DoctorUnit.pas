unit DoctorUnit;

interface

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
    constructor Create(
      ADoctorID: Integer;
      AFirstName: string;
      ALastName: string;
      ASpecialization: string;
      APhoneNumber: string;
      AEmail: string
    );

    function GetFullName: string;

    property DoctorID: Integer read FDoctorId write FDoctorId;
    property FirstName: string read FFirstName write FFirstName;
    property LastName: string read FLastName write FLastName;
    property Specialization: string read FSpecialization write FSpecialization;
    property PhoneNumber: string read FPhoneNumber write FPhoneNumber;
    property Email: string read FEmail write FEmail;
  end;

implementation

constructor TDoctor.Create(ADoctorID: Integer; AFirstName: string; ALastName: string; ASpecialization: string; APhoneNumber: string; AEmail: string);
begin
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
