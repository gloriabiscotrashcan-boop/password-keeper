unit mylibrary;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,
  DCPblowfish, DCPsha256, DCPmd5
  ;

const
  qry0001 = 'select * from owner where name = :aUserName';
  qry0002 = 'select * from password where owner = :aUserName';
  qry0011 = 'update owner set oldpass = :aoldpass where name = :ausername';
  qry0012 = 'update owner set newpass = :anewpass where name = :ausername';
  qry0021 = 'insert into owner (name, oldpass, newpass) values (:ausername, :aoldpass, :anewpass)';

  aPasskey = 'bahwa sesungguhnya kemerdekaan itu ialah hak segala bangsa dan oleh sebab itu maka penjajahan di atas dunia harus dihapuskan karena tidak sesuai dengan perikemanusiaan dan perikeadilan';

function DoEncrypt(aPlainText : String; aPassword : String; aMode : Integer) : String;
function DoDecrypt(aCipherText : String; aPassword : String; aMode : Integer) : String;

function UserPassMaker(aPassword: String): String;
function SitePassMaker(aOwnerPass : String; aAccountPass : String; aAccountName : String): String;
function SitePassReader(aOwnerPass : String; aAccountPass : String; aAccountName : String): String;

implementation

function DoEncrypt(aPlainText: String; aPassword: String; aMode : Integer): String;
var aEncrypted : String;
    aCipher    : TDCP_Blowfish;
begin
aCipher := TDCP_Blowfish.Create(nil);
case aMode of
     1 : begin
         aCipher.InitStr(Trim(aPassword), TDCP_SHA256);
         end;
     2 : begin
         aCipher.InitStr(Trim(aPassword), TDCP_MD5);
         end;
     end;
aEncrypted := aCipher.EncryptString(Trim(aPlainText));
aCipher.Burn;
aCipher.Free;
Result := aEncrypted;
end;

function DoDecrypt(aCipherText: String; aPassword: String; aMode : Integer): String;
var aDecrypted : String;
    aCipher    : TDCP_Blowfish;
begin
aCipher := TDCP_Blowfish.Create(nil);
case aMode of
     1 : begin
         aCipher.InitStr(Trim(aPassword), TDCP_SHA256);
         end;
     2 : begin
         aCipher.InitStr(Trim(aPassword), TDCP_MD5);
         end;
     end;
aDecrypted := aCipher.DecryptString(aCipherText);
aCipher.Burn;
aCipher.Free;
Result := aDecrypted;
end;

function UserPassMaker(aPassword: String): String;
var aResult : String;
begin
aResult := DoEncrypt(aPassword, aPassword, 1);
Result := aResult;
end;

function SitePassMaker(aOwnerPass : String; aAccountPass : String; aAccountName : String): String;
var aKey    : String;
    aResult : String;
begin
// aOwnerPass = plaintext, passed from login
// aAccountPass = plaintext from editbox
// aAccountName = plaintext from editbox

// aPass = aAccountName encrypted with aOwnerPass
// aResult = aAccountPass encrypted with aPass
// aResult will be saved into database

aKey := DoEncrypt(Trim(aAccountName), Trim(aOwnerPass), 1);
aResult := DoEncrypt(aAccountPass, aKey, 2);
Result := aResult;
end;

function SitePassReader(aOwnerPass : String; aAccountPass : String; aAccountName : String): String;
var aKey    : String;
    aResult : String;
begin
// aOwnerPass = plaintext, passed from login
// aAccountPass = encrypted text from database
// aAccountName = plaintext from editbox

// aPass = aAccountName encrypted with aOwnerPass
// aResult = aAccountPass decrypted with aPass

aKey := DoEncrypt(Trim(aAccountName), Trim(aOwnerPass), 1);
aResult := DoDecrypt(aAccountPass, aKey, 2);

Result := aResult;
end;



end.

