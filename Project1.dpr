program Project1;

uses
  Forms,
  user in 'user.pas' {Form1},
  login in 'login.pas' {Form2},
  admin in 'admin.pas' {Form3},
  register in 'register.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
