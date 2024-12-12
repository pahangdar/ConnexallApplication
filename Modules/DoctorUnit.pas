unit DoctorUnit;

interface

type
  TDoctor = class
  private
    FDoctorID: Integer;
    FFirstName: string;
    FLastName: string;
  public
    constructor Create(
      ADoctorID: Integer;
      AFirstName: string;
      ALastName: string
    );

    function GetFullName: string;

    property DoctorID: Integer read FDoctorId write FDoctorId;
    property FirstName: string read FFirstName write FFirstName;
    property LastName: string read FLastName write FLastName;
  end;

implementation

constructor TDoctor.Create(ADoctorID: Integer; AFirstName: string; ALastName: string);
begin
  FDoctorID := ADoctorID;
  FFirstName := AFirstName;
  FLastName := ALastName;
end;

function TDoctor.GetFullName: string;
begin
  Result := FFirstName + ' ' + FLastName;
end;

end.
