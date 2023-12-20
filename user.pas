unit user;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Grids, DBGrids, SMDBGrid, DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, Mask, DBCtrls, SMDBCtrl,
  SMDBFind, SMDBFltr, frxClass, frxDBSet, mxExport, jpeg;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Label4: TLabel;
    BitBtn1: TBitBtn;
    Label5: TLabel;
    Label6: TLabel;
    SMDBGrid1: TSMDBGrid;
    keranjang_ds: TDataSource;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    keranjang_zq: TZQuery;
    SMDBFilterDialog1: TSMDBFilterDialog;
    SMDBFindDialog1: TSMDBFindDialog;
    mxDBGridExport1: TmxDBGridExport;
    Edit1: TEdit;
    BitBtn2: TBitBtn;
    Edit2: TEdit;
    SMDBNavigator1: TSMDBNavigator;
    Label7: TLabel;
    Label8: TLabel;
    BitBtn3: TBitBtn;
    Label9: TLabel;
    BitBtn4: TBitBtn;
    SMDBFindDialog2: TSMDBFindDialog;
    SMDBFilterDialog2: TSMDBFilterDialog;
    BitBtn5: TBitBtn;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure InsertToKeranjang(bukuID, anggotaID: Integer);
    procedure Image2Click(Sender: TObject);
    procedure SMDBGrid1CellClick(Column: TColumn);
    procedure SMDBNavigator1Click(Sender: TObject; Button: TSMNavigateBtn);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure Image8Click(Sender: TObject);
    procedure Image9Click(Sender: TObject);

  private
    { Private declarations }

    anggota_id: Integer;
  public
    { Public declarations }
    currentUserID: Integer;
    procedure ShowUserData(anggotaID: Integer);
  end;

var
  Form1: TForm1;
  currentUserID: Integer;
  GetCurrentUser: Integer;

implementation

uses
  login, admin;

var
  judul, penulis, kategori: string;
  tarif_sewa, buku_id: integer;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);

begin

  ComboBox1.Items.Add('Novel');
  ComboBox1.Items.Add('Pelajaran');

  if Assigned(Form2) then
    currentUserID := Form2.currentUserID;

  ShowUserData(currentUserID);

end;


procedure TForm1.ShowUserData(anggotaID: Integer);
begin
  keranjang_zq.Close;
  keranjang_zq.SQL.Text := 'SELECT * FROM keranjang WHERE anggota_id = :anggota_id';
  keranjang_zq.ParamByName('anggota_id').AsInteger := anggotaID;
  keranjang_zq.Open;

  keranjang_ds.DataSet := keranjang_zq;
end;


procedure TForm1.BitBtn1Click(Sender: TObject);
var
  lama_pinjam, total, tarif_sewa: Integer;
begin

  if TryStrToInt(Edit1.Text, lama_pinjam) then
  begin
    try
      // Cek apakah buku sudah ada di tabel keranjang
      keranjang_zq.Close;
      keranjang_zq.SQL.Text :=
        'SELECT * FROM keranjang WHERE buku_id = :buku_id AND anggota_id = :anggota_id';
      keranjang_zq.ParamByName('buku_id').AsInteger := buku_id;
      keranjang_zq.ParamByName('anggota_id').AsInteger := Form1.currentUserID;
      keranjang_zq.Open;

      if not keranjang_zq.IsEmpty then
      begin
        // Buku sudah ada
        keranjang_zq.Edit;
        keranjang_zq.FieldByName('lama_pinjam').AsInteger :=
          keranjang_zq.FieldByName('lama_pinjam').AsInteger + lama_pinjam;
        total := keranjang_zq.FieldByName('lama_pinjam').AsInteger *
          keranjang_zq.FieldByName('tarif_sewa').AsInteger;
        keranjang_zq.FieldByName('total').AsInteger := total;

        keranjang_zq.Post;
      end
      else
      begin
        // Buku belum ada
        keranjang_zq.Close;
        keranjang_zq.SQL.Text := 'SELECT tarif_sewa FROM buku WHERE buku_id = :buku_id';
        keranjang_zq.ParamByName('buku_id').AsInteger := buku_id;
        keranjang_zq.Open;

        if not keranjang_zq.IsEmpty then
        begin
          tarif_sewa := keranjang_zq.FieldByName('tarif_sewa').AsInteger;

          keranjang_zq.Close;
          keranjang_zq.SQL.Text :=
            'INSERT INTO keranjang (buku_id, anggota_id, judul, penulis, kategori, tarif_sewa, lama_pinjam, total) ' +
            'VALUES (:buku_id, :anggota_id, :judul, :penulis, :kategori, :tarif_sewa, :lama_pinjam, :total)';
          keranjang_zq.ParamByName('buku_id').AsInteger := buku_id;
          keranjang_zq.ParamByName('anggota_id').AsInteger := Form1.currentUserID;
          keranjang_zq.ParamByName('judul').AsString := judul;
          keranjang_zq.ParamByName('penulis').AsString := penulis;
          keranjang_zq.ParamByName('kategori').AsString := kategori;
          keranjang_zq.ParamByName('tarif_sewa').AsInteger := tarif_sewa;
          keranjang_zq.ParamByName('lama_pinjam').AsInteger := lama_pinjam;

          total := lama_pinjam * tarif_sewa;
          keranjang_zq.ParamByName('total').AsInteger := total;

          keranjang_zq.ExecSQL;
        end;
      end;


      keranjang_zq.SQL.Text := 'SELECT * FROM keranjang WHERE anggota_id = :anggota_id';
      keranjang_zq.ParamByName('anggota_id').AsInteger := Form1.currentUserID;
      keranjang_zq.Open;
      keranjang_ds.DataSet := keranjang_zq;

      Edit1.Text := '';

      ShowMessage('Data berhasil disimpan ke tabel keranjang.');
    except
      on E: Exception do
        
        ShowMessage('Error: ' + E.Message);
    end;
  end
  else

    ShowMessage('Masukkan angka yang valid pada kolom lama pinjam.');
end;


procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  // Set visibility for the first set of images
  Image1.Visible := True;
  Image2.Visible := True;
  Image3.Visible := True;
  Image4.Visible := True;

  // Hide the second set of images
  Image6.Visible := False;
  Image7.Visible := False;
  Image8.Visible := False;
  Image9.Visible := False;

  // Load images based on ComboBox selection
  if ComboBox1.Text = 'Novel' then
  begin
    Image1.Picture.LoadFromFile('images/Laskar_Pelangi_film.bmp');
    Image2.Picture.LoadFromFile('images/in-blue-moon.bmp');
    Image3.Picture.LoadFromFile('images/buku1.bmp');
    Image4.Picture.LoadFromFile('images/buku2.bmp');
  end
  else if ComboBox1.Text = 'Pelajaran' then
  begin
    // Set visibility for the second set of images
    Image6.Visible := True;
    Image7.Visible := True;
    Image8.Visible := True;
    Image9.Visible := True;

    Image1.Picture.LoadFromFile('images/diriku.bmp');
    Image2.Picture.LoadFromFile('images/kegiatanku.bmp');
    Image3.Picture.LoadFromFile('images/hiduprukun.bmp');
    Image4.Picture.LoadFromFile('images/kegemaranku.bmp');
  end;
end;


procedure TForm1.InsertToKeranjang(bukuID, anggotaID: Integer);
var
  lama_pinjam, total: Integer;
begin
  try
    
    keranjang_zq.Close;
    keranjang_zq.SQL.Text := 'SELECT * FROM keranjang WHERE buku_id = :buku_id AND anggota_id = :anggota_id';
    keranjang_zq.ParamByName('buku_id').AsInteger := bukuID;
    keranjang_zq.ParamByName('anggota_id').AsInteger := anggotaID;
    keranjang_zq.Open;

    if not keranjang_zq.IsEmpty then
    begin
      ShowMessage('Buku sudah ada di keranjang');


      keranjang_zq.Close;
      keranjang_zq.SQL.Text :=
        'SELECT * FROM keranjang WHERE anggota_id = :anggota_id';
      keranjang_zq.ParamByName('anggota_id').AsInteger := Form1.currentUserID; // Use currentUserID from Form1
      keranjang_zq.Open;
      Edit1.Enabled := False;

      Exit;
    end;


    keranjang_zq.Close;
    keranjang_zq.SQL.Text := 'SELECT * FROM buku WHERE buku_id = :buku_id';
    keranjang_zq.ParamByName('buku_id').AsInteger := bukuID;
    keranjang_zq.Open;

    if not keranjang_zq.IsEmpty then
    begin

      buku_id := keranjang_zq.FieldByName('buku_id').AsInteger;
      judul := keranjang_zq.FieldByName('judul').AsString;
      penulis := keranjang_zq.FieldByName('penulis').AsString;
      kategori := keranjang_zq.FieldByName('kategori').AsString;
      tarif_sewa := keranjang_zq.FieldByName('tarif_sewa').AsInteger;

      if TryStrToInt(Edit1.Text, lama_pinjam) then
      begin
        keranjang_zq.Append;


        keranjang_zq.FieldByName('buku_id').AsInteger := buku_id;
        keranjang_zq.FieldByName('anggota_id').AsInteger := anggotaID;
        keranjang_zq.FieldByName('judul').AsString := judul;
        keranjang_zq.FieldByName('penulis').AsString := penulis;
        keranjang_zq.FieldByName('kategori').AsString := kategori;
        keranjang_zq.FieldByName('tarif_sewa').AsInteger := tarif_sewa;
        keranjang_zq.FieldByName('lama_pinjam').AsInteger := lama_pinjam;

        total := lama_pinjam * tarif_sewa;
        keranjang_zq.FieldByName('total').AsInteger := total;

        keranjang_zq.Post;
      end
      else
      begin
        ShowMessage('Masukkan lama pinjam!');
      end;
    end
    else
    begin
      ShowMessage('Buku tidak ditemukan.');
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Error: ' + E.Message);
    end;
  end;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  InsertToKeranjang(100, anggota_id);
end;
procedure TForm1.Image2Click(Sender: TObject);
begin
  InsertToKeranjang(101, anggota_id);
end;

procedure TForm1.SMDBGrid1CellClick(Column: TColumn);
  var
  lama_pinjam: Integer;
  begin

    if not SMDBGrid1.DataSource.DataSet.IsEmpty then
    begin

      lama_pinjam := SMDBGrid1.DataSource.DataSet.FieldByName('lama_pinjam').AsInteger;

      Edit2.Text := IntToStr(lama_pinjam);
    end;

end;
procedure TForm1.SMDBNavigator1Click(Sender: TObject;
  Button: TSMNavigateBtn);
begin
  case Button of
    sbFind: SMDBFindDialog1.Execute;
    sbFilter: SMDBFilterDialog1.Execute;
    sbExport: mxDBGridExport1.Select;
  end;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var
  lama_pinjam, total: Integer;
begin

  if TryStrToInt(Edit2.Text, lama_pinjam) then
  begin
    try

      keranjang_zq.Edit;
      keranjang_zq.FieldByName('lama_pinjam').AsInteger := lama_pinjam;


      total := lama_pinjam * keranjang_zq.FieldByName('tarif_sewa').AsInteger;
      keranjang_zq.FieldByName('total').AsInteger := total;

      keranjang_zq.Post;

      keranjang_ds.DataSet := keranjang_zq;

      ShowMessage('Total updated successfully.');
    except
      on E: Exception do
        ShowMessage('Error updating total: ' + E.Message);
    end;
  end
  else
    ShowMessage('Masukkan angka yang valid pada kolom lama pinjam.');
end;


procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  try

    if keranjang_zq.IsEmpty then
    begin
      ShowMessage('Tidak ada data yang dipilih.');
      Exit;
    end;

    if MessageDlg('Anda yakin ingin menghapus data ini?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin

      keranjang_zq.Delete;

      keranjang_zq.ApplyUpdates;

      keranjang_ds.DataSet := keranjang_zq;

      ShowMessage('Data berhasil dihapus.');
    end;
  except
    on E: Exception do
      ShowMessage('Error deleting data: ' + E.Message);
  end;
end;


procedure TForm1.Image3Click(Sender: TObject);
begin
  InsertToKeranjang(102, anggota_id);
end;

procedure TForm1.Image4Click(Sender: TObject);
begin
  InsertToKeranjang(103, anggota_id);
end;


procedure TForm1.BitBtn4Click(Sender: TObject);
var
  id_keranjang, buku_id, lama_pinjam, total: Integer;
begin
  keranjang_zq.SQL.Text := 'SELECT * FROM keranjang WHERE anggota_id = ' + IntToStr(currentUserID);

  try
    keranjang_zq.Open;

    while not keranjang_zq.Eof do
    begin
      id_keranjang := keranjang_zq.FieldByName('id_keranjang').AsInteger;
      buku_id := keranjang_zq.FieldByName('buku_id').AsInteger;
      lama_pinjam := keranjang_zq.FieldByName('lama_pinjam').AsInteger;
      total := keranjang_zq.FieldByName('total').AsInteger;

      try
        // Insert Data into "peminjaman" Table
        Form3.peminjaman_zq.SQL.Text :=
          'INSERT INTO peminjaman (id_keranjang, anggota_id, buku_id, lama_pinjam, total) VALUES (:id_keranjang, :anggota_id, :buku_id, :lama_pinjam, :total)';

        // Set parameter values
        Form3.peminjaman_zq.ParamByName('id_keranjang').AsInteger := id_keranjang;
        Form3.peminjaman_zq.ParamByName('anggota_id').AsInteger := currentUserID;
        Form3.peminjaman_zq.ParamByName('buku_id').AsInteger := buku_id;
        Form3.peminjaman_zq.ParamByName('lama_pinjam').AsInteger := lama_pinjam;
        Form3.peminjaman_zq.ParamByName('total').AsInteger := total;

        Form3.peminjaman_zq.ExecSQL;

        // Move to the Next Record in the "keranjang" Table
        keranjang_zq.Next;
      except
        on E: Exception do
        begin
          // Handle exceptions, close the dataset if an error occurs
          ShowMessage('Error: ' + E.Message);
          keranjang_zq.Close;
          Exit; // Exit the procedure if an error occurs during the main transaction
        end;
      end;
    end;

    // Delete Data from "keranjang" Table
    keranjang_zq.Close;
    keranjang_zq.SQL.Text := 'DELETE FROM keranjang WHERE anggota_id = ' + IntToStr(currentUserID);
    keranjang_zq.ExecSQL;
  finally
    // Close the dataset
    keranjang_zq.Close;
  end;
  ShowMessage('Peminjaman berhasil dilakukan dan data di keranjang dihapus');
end;






procedure TForm1.BitBtn5Click(Sender: TObject);
begin
  Form2.Show;
  Form1.Hide;
  Form2.Edit1.Text := '';
  Form2.Edit2.Text := '';
  Close;
end;

procedure TForm1.Image6Click(Sender: TObject);
begin
  InsertToKeranjang(104, anggota_id);
end;

procedure TForm1.Image7Click(Sender: TObject);
begin
  InsertToKeranjang(105, anggota_id);
end;

procedure TForm1.Image8Click(Sender: TObject);
begin
  InsertToKeranjang(106, anggota_id);
end;

procedure TForm1.Image9Click(Sender: TObject);
begin
  InsertToKeranjang(107, anggota_id);
end;

end.

