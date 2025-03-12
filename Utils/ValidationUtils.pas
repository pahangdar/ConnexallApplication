unit ValidationUtils;

interface

uses
  System.SysUtils, System.RegularExpressions;

function IsValidEmail(const Email: string): Boolean;
function IsValidPhoneNumber(const PhoneNumber: string): Boolean;

implementation

function IsValidEmail(const Email: string): Boolean;
const
  EMAIL_REGEX = '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';
begin
  Result := TRegEx.IsMatch(Email, EMAIL_REGEX);
end;

function IsValidPhoneNumber(const PhoneNumber: string): Boolean;
const
  PHONE_REGEX = '^\+?[0-9\s\-()]{7,15}$';
begin
  Result := TRegEx.IsMatch(PhoneNumber, PHONE_REGEX);
end;

end.

