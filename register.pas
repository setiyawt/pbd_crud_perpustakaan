unit register;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, DBEditDateTimePicker, StdCtrls, Buttons, jpeg,
  ExtCtrls;

type
  TForm4 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Edit3: TEdit;
    Label5: TLabel;
    Edit4: TEdit;
    ScrollBox1: TScrollBox;
    Label6: TLabel;
    Edit5: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Edit6: TEdit;
    Label9: TLabel;
    Edit7: TEdit;
    Label10: TLabel;
    Edit8: TEdit;
    DateTimePicker1: TDateTimePicker;
    BitBtn1: TBitBtn;
    CheckBox1: TCheckBox;
    Label11: TLabel;
    Label12: TLabel;
    Image1: TImage;
    procedure CheckBox1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Label12Click(Sender: TObject);
    
  private
    { Private declarations }
    function CekUsernameSudahTerdaftar(username: string): string;
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

uses login;

{$R *.dfm}



procedure TForm4.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
    Edit2.PasswordChar := #0
  else
    Edit2.PasswordChar := '*';
end;

procedure TForm4.BitBtn1Click(Sender: TObject);
var
  existingUsername: string;
begin
  Form2.login_zq.Close;

  existingUsername := CekUsernameSudahTerdaftar(Edit1.Text);
  if existingUsername <> '' then
  begin
    ShowMessage('Username ' + existingUsername + ' sudah terdaftar. Silakan pilih username lain.');
    Exit;
  end;

  if (Edit1.Text = '') or (Edit2.Text = '') or (Edit3.Text = '') or (Edit4.Text = '') or
     (Edit5.Text = '') or (Edit6.Text = '') or (Edit7.Text = '') or (Edit8.Text = '')
     then
  begin
    ShowMessage('Harap isi semua field sebelum mendaftar.');
    Exit;
  end;

  Form2.login_zq.SQL.Text :=
    'INSERT INTO anggota(anggota_id, username, password, email, nama, noHp, ' +
    'tgl_gabung, nama_jln, kota, kodepos, aktif, level) ' +
    'VALUES (:anggota_id, :username, :password, :email, :nama, :noHp, ' +
    ':tgl_gabung, :nama_jln, :kota, :kodepos, :aktif, :level)';

  Form2.login_zq.ParamByName('username').AsString := Edit1.Text;
  Form2.login_zq.ParamByName('password').AsString := Edit2.Text;
  Form2.login_zq.ParamByName('email').AsString := Edit3.Text;
  Form2.login_zq.ParamByName('nama').AsString := Edit4.Text;
  Form2.login_zq.ParamByName('noHp').AsString := Edit5.Text;
  Form2.login_zq.ParamByName('tgl_gabung').AsDateTime := DateTimePicker1.DateTime;
  Form2.login_zq.ParamByName('nama_jln').AsString := Edit6.Text;
  Form2.login_zq.ParamByName('kota').AsString := Edit7.Text;
  Form2.login_zq.ParamByName('kodepos').AsString := Edit8.Text;

  Form2.login_zq.ParamByName('aktif').AsString := 'Y';
  Form2.login_zq.ParamByName('level').AsString := 'user';

  Form2.login_zq.ExecSQL;

  ShowMessage('Data anggota berhasil dimasukkan ke dalam database.');
  Edit1.Text := '';
  Edit2.Text := '';
  Edit3.Text := '';
  Edit4.Text := '';
  Edit5.Text := '';
  Edit6.Text := '';
  Edit7.Text := '';
  Edit8.Text := '';
end;

function TForm4.CekUsernameSudahTerdaftar(username: string): string;
begin
  
  Form2.login_zq.Close;
  Form2.login_zq.SQL.Text := 'SELECT username FROM anggota WHERE username = :username';
  Form2.login_zq.ParamByName('username').AsString := username;
  Form2.login_zq.Open;

  if not Form2.login_zq.IsEmpty then
    Result := Form2.login_zq.FieldByName('username').AsString
  else
    Result := '';
end;


procedure TForm4.Label12Click(Sender: TObject);
begin
  Form4.Hide;
  Form2.Show;
end;

end.
