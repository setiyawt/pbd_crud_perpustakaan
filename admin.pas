unit admin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ZAbstractRODataset, ZAbstractDataset, ZDataset, Grids,
  DBGrids, SMDBGrid, StdCtrls, ExtCtrls, SMDBCtrl, Buttons, ComCtrls,
  DBEditDateTimePicker, frxClass, frxDBSet, mxExport, SMDBFind, SMDBFltr,
  Menus, ImgList, EDBImage, jpeg, frxChBox;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    ScrollBox1: TScrollBox;
    SMDBGrid1: TSMDBGrid;
    Label2: TLabel;
    anggota_ds: TDataSource;
    anggota_zq: TZQuery;
    Label3: TLabel;
    SMDBNavigator1: TSMDBNavigator;
    peminjaman_ds: TDataSource;
    peminjaman_zq: TZQuery;
    SMDBNavigator2: TSMDBNavigator;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    anggota_zqanggota_id: TIntegerField;
    anggota_zqusername: TStringField;
    anggota_zqpassword: TStringField;
    anggota_zqemail: TStringField;
    anggota_zqnama: TStringField;
    anggota_zqnoHp: TStringField;
    anggota_zqtgl_gabung: TDateField;
    anggota_zqnama_jln: TStringField;
    anggota_zqkota: TStringField;
    anggota_zqkodepos: TStringField;
    anggota_zqaktif: TBooleanField;
    anggota_zqlevel: TStringField;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    BitBtn1: TBitBtn;
    buku_zq: TZQuery;
    keranjang_zq: TZQuery;
    CheckBox1: TCheckBox;
    DateTimePicker1: TDateTimePicker;
    SMDBFilterDialog1: TSMDBFilterDialog;
    SMDBFindDialog1: TSMDBFindDialog;
    mxDBGridExport1: TmxDBGridExport;
    frxReport1: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    peminjaman_zqpeminjaman_id: TIntegerField;
    peminjaman_zqid_keranjang: TIntegerField;
    peminjaman_zqanggota_id: TIntegerField;
    peminjaman_zqbuku_id: TIntegerField;
    peminjaman_zqrf_nohp_anggota: TStringField;
    peminjaman_zqrf_buku_judul: TStringField;
    peminjaman_zqrf_buku_penulis: TStringField;
    peminjaman_zqrf_tarif_sewa: TIntegerField;
    SMDBGrid2: TSMDBGrid;
    peminjaman_zqrf_nama_anggota: TStringField;
    EDBImage1: TEDBImage;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    Load1: TMenuItem;
    Save1: TMenuItem;
    Delete1: TMenuItem;
    peminjaman_zqfoto: TBlobField;
    BitBtn2: TBitBtn;
    peminjaman_zqlama_pinjam: TIntegerField;
    peminjaman_zqtotal: TIntegerField;
    Image1: TImage;
    SMDBFilterDialog2: TSMDBFilterDialog;
    SMDBFindDialog2: TSMDBFindDialog;
    mxDBGridExport2: TmxDBGridExport;
    frxReport2: TfrxReport;
    frxDBDataset2: TfrxDBDataset;
    frxCheckBoxObject1: TfrxCheckBoxObject;
    procedure SMDBGrid1CellClick(Column: TColumn);
    procedure BitBtn1Click(Sender: TObject);
    procedure SMDBNavigator1Click(Sender: TObject; Button: TSMNavigateBtn);
    procedure Load1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure SMDBNavigator2Click(Sender: TObject; Button: TSMNavigateBtn);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses login, myLib_Blob;

{$R *.dfm}

procedure TForm3.SMDBGrid1CellClick(Column: TColumn);
var
  anggota_id: Integer;
  username, password, email, nama, nohp, nama_jln, kota, kodepos: string;
  tgl_gabung: TDateTime;
  aktif: Boolean;
begin
  if not SMDBGrid1.DataSource.DataSet.IsEmpty then
  begin
    anggota_id := SMDBGrid1.DataSource.DataSet.FieldByName('anggota_id').AsInteger;
    username := SMDBGrid1.DataSource.DataSet.FieldByName('username').AsString;
    password := SMDBGrid1.DataSource.DataSet.FieldByName('password').AsString;
    email := SMDBGrid1.DataSource.DataSet.FieldByName('email').AsString;
    nama := SMDBGrid1.DataSource.DataSet.FieldByName('nama').AsString;
    nohp := SMDBGrid1.DataSource.DataSet.FieldByName('noHp').AsString;
    tgl_gabung := SMDBGrid1.DataSource.DataSet.FieldByName('tgl_gabung').AsDateTime;  // AsDateTime untuk tipe data DateTime
    nama_jln := SMDBGrid1.DataSource.DataSet.FieldByName('nama_jln').AsString;
    kota := SMDBGrid1.DataSource.DataSet.FieldByName('kota').AsString;
    kodepos := SMDBGrid1.DataSource.DataSet.FieldByName('kodepos').AsString;
    aktif := SMDBGrid1.DataSource.DataSet.FieldByName('aktif').AsBoolean;

    Edit1.Text := IntToStr(anggota_id);
    Edit2.Text := username;
    Edit3.Text := password;
    Edit4.Text := email;
    Edit5.Text := nama;
    Edit6.Text := nohp;

    DateTimePicker1.Date := tgl_gabung;
    Edit8.Text := nama_jln;
    Edit9.Text := kota;
    Edit10.Text := kodepos;
    CheckBox1.Checked := aktif;
  end;
end;

procedure TForm3.BitBtn1Click(Sender: TObject);
var
  anggota_id: Integer;
  username, password, email, nama, nohp, nama_jln, kota, kodepos: string;
  tgl_gabung: TDateTime;
  aktif: Boolean;
begin
  try
    // Retrieve the values of the selected record
    anggota_id := anggota_zq.FieldByName('anggota_id').AsInteger;
    username := anggota_zq.FieldByName('username').AsString;
    password := anggota_zq.FieldByName('password').AsString;
    email := anggota_zq.FieldByName('email').AsString;
    nama := anggota_zq.FieldByName('nama').AsString;
    nohp := anggota_zq.FieldByName('nohp').AsString;
    //tgl_gabung := anggota_zq.FieldByName('tgl_gabung').AsDateTime;
    nama_jln := anggota_zq.FieldByName('nama_jln').AsString;
    kota := anggota_zq.FieldByName('kota').AsString;
    kodepos := anggota_zq.FieldByName('kodepos').AsString;
    //aktif := anggota_zq.FieldByName('aktif').AsBoolean;

    // Edit the values if needed (for example, modify 'nama' field)
    userName := Edit2.Text;
    password := Edit3.Text;
    email := Edit4.Text;
    nama := Edit5.Text;
    nohp := Edit6.Text;
    tgl_gabung := DateTimePicker1.DateTime;
    nama_jln := Edit8.Text;
    kota := Edit9.Text;
    kodepos := Edit10.Text;
    aktif := CheckBox1.Checked;

    // Start editing the record
    anggota_zq.Edit;

    // Update the fields with modified values
    anggota_zq.FieldByName('anggota_id').AsInteger := anggota_id;
    anggota_zq.FieldByName('username').AsString := username;
    anggota_zq.FieldByName('password').AsString := password;
    anggota_zq.FieldByName('email').AsString := email;
    anggota_zq.FieldByName('nama').AsString := nama;
    anggota_zq.FieldByName('nohp').AsString := nohp;
    anggota_zq.FieldByName('tgl_gabung').AsDateTime := tgl_gabung;
    anggota_zq.FieldByName('nama_jln').AsString := nama_jln;
    anggota_zq.FieldByName('kota').AsString := kota;
    anggota_zq.FieldByName('kodepos').AsString := kodepos;
    anggota_zq.FieldByName('aktif').AsBoolean := aktif;

    // Post the changes
    anggota_zq.Post;

    // Apply the updates to the dataset
    anggota_zq.ApplyUpdates;

    // Refresh the dataset linked to data source
    anggota_ds.DataSet.Refresh;

    ShowMessage('Data berhasil diedit');
  except
    on E: Exception do
      ShowMessage('Error updating data: ' + E.Message);
  end;
end;


procedure TForm3.SMDBNavigator1Click(Sender: TObject;
  Button: TSMNavigateBtn);
begin
  case Button of
    sbFind: SMDBFindDialog1.Execute;
    sbFilter: SMDBFilterDialog1.Execute;
    sbExport: mxDBGridExport1.Select;
    sbPrint: frxReport1.ShowReport;
  end;
end;



procedure TForm3.Load1Click(Sender: TObject);
begin
  Blob_FromFileImage(peminjaman_zqfoto);
end;

procedure TForm3.Save1Click(Sender: TObject);
begin
  Blob_ToFileImage(peminjaman_zqfoto);
end;

procedure TForm3.Delete1Click(Sender: TObject);
begin
  Blob_Clear(peminjaman_zqfoto, 'Apakah foto akan dihapus?');
end;

procedure TForm3.BitBtn2Click(Sender: TObject);
begin
  Form3.Hide;
  Form2.Show;
  Form2.Edit1.Text := '';
  Form2.Edit2.Text := '';
  Close;
end;


procedure TForm3.SMDBNavigator2Click(Sender: TObject;
  Button: TSMNavigateBtn);
begin
  case Button of
    sbFind: SMDBFindDialog2.Execute;
    sbFilter: SMDBFilterDialog2.Execute;
    sbExport: mxDBGridExport2.Select;
    sbPrint: frxReport2.ShowReport;
  end;
end;

end.
