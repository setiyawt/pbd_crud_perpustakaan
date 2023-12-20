unit login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, ZAbstractRODataset, ZAbstractDataset,
  ZDataset, ZAbstractConnection, ZConnection, ExtCtrls, jpeg;

type
  TForm2 = class(TForm)
    lbl1: TLabel;
    Username: TLabel;
    Edit1: TEdit;
    Password: TLabel;
    Edit2: TEdit;
    CheckBox1: TCheckBox;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    ZConnection1: TZConnection;
    login_zq: TZQuery;
    Image1: TImage;
    procedure BitBtn1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    currentUserID: Integer;
  end;

var
  Form2: TForm2;

implementation

uses admin, user, register;

var
  z: integer;
  a, b, c: string;


{$R *.dfm}

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
  login_zq.SQL.Text := 'SELECT anggota_id, username, password, level FROM anggota WHERE username = :username AND password = :password';
  login_zq.ParamByName('username').AsString := Edit1.Text;
  login_zq.ParamByName('password').AsString := Edit2.Text;
  login_zq.Active := True;

  try
    login_zq.Open;

    if not login_zq.IsEmpty then
    begin
      currentUserID := login_zq.FieldByName('anggota_id').AsInteger;

      z := 0;

      login_zq.First;
      while not login_zq.Eof do
      begin
        a := login_zq['level'];
        b := login_zq['username'];
        c := login_zq['password'];

        if (Edit1.Text = b) and (Edit2.Text = c) then
        begin
          if a = 'admin' then
            z := 1
          else if a = 'user' then
            z := 2;

          Break;
        end;

        login_zq.Next;
      end;

      case z of
        1:
          begin
            Form3.anggota_zq.Active := True;
            Form3.peminjaman_zq.Active := True;
            Form3.keranjang_zq.Active := True;
            Form3.buku_zq.Active := True;
            MessageDlg('Selamat datang Admin', mtInformation, [mbOK], 0);
            Form2.Hide;
            Form3.Show;
          end;
        2:
          begin
            MessageDlg('Selamat datang User', mtInformation, [mbOK], 0);

            currentUserID := login_zq.FieldByName('anggota_id').AsInteger;
            Form1.keranjang_zq.Close;
            Form1.keranjang_zq.SQL.Text :=
              'SELECT * FROM keranjang WHERE anggota_id = :anggota_id';
            Form1.keranjang_zq.ParamByName('anggota_id').AsInteger := currentUserID;
            Form1.keranjang_zq.Open;
            Form2.Hide;
            
            Form1.currentUserID := currentUserID;
            Form1.Show;
          end;
        0:
          MessageDlg('Login gagal karena username atau password salah!', mtInformation, [mbOK], 0);
      end;
    end
    else
    begin
      MessageDlg('Login gagal karena username atau password salah!', mtInformation, [mbOK], 0);
    end;
  finally
    login_zq.Close;
  end;
end;


procedure TForm2.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
    Edit2.PasswordChar := #0
  else
    Edit2.PasswordChar := '*';
end;


procedure TForm2.Label2Click(Sender: TObject);
begin
  Form2.Hide;
  Form4.Show;
end;



end.

