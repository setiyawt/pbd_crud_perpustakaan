{——————————————————————————————————————————————————— Mic86 Software Ltd ——
| Project : Universsal
| Unit    : myLib_Blob.pas
| Comment :
|
|    Date : 24-05-2021   19:49
|  Author : M.Ichwan
|-------------------------------------------------------
| Last modified
|    Date : Sen   19:49
|
|       Copyright (C) 2021 Mic86 Software Ltd
|
| Compiler : Delphi 7
|—————————————————————————————————————————————————————————————————————————————}
unit myLib_Blob;

interface

uses
  DB,Classes,SysUtils, jpeg, ExtDlgs, Windows  ;

function Blob_FromFile(pBlobField:TField;pFileName:String):Integer;
function Blob_ToFile(pBlobField:TField;pFileName:String):Integer;
function Blob_FromFileImage(pBlobField:TField):Boolean;
function Blob_ToFileImage(pBlobField:TField):boolean;
function Blob_Clear(pBlobField:TField;msg:String):Boolean;

implementation

function Blob_FromFile(pBlobField:TField;pFileName:String):Integer;
var
  blob : TStream;   {uses Classes }
  xDataset : TDataSet;
  fs : TStream;
begin
  xDataset := pBlobField.DataSet;
  blob := xDataSet.CreateBlobStream(pBlobField, bmWrite);
  try
    blob.Seek(0, soFromBeginning);
    fs := TFileStream.Create(pFileName, fmOpenRead or fmShareDenyWrite);
    try
      blob.CopyFrom(fs, fs.Size);
      Result := fs.Size;
    except
      Result := -2;
    End;
    fs.Free;
  except
    Result := -1;
  End;
  blob.Free ;
End;

function Blob_ToFile(pBlobField:TField;pFileName:String):Integer;
var
    blob : TStream;   {uses Classes }
    xDataset : TDataSet;
begin
    xDataset := pBlobField.DataSet;
    blob := xDataSet.CreateBlobStream(pBlobField, bmRead);
   try
      blob.Seek(0, soFromBeginning);
      with TFileStream.Create(pFileName, fmCreate) do
      try
        Result := -1;
        CopyFrom(blob, blob.Size);
        Result := blob.Size;
       finally
         Free
       end;
    finally
      blob.Free
   end;
 end;

function Blob_FromFileImage(pBlobField:TField):boolean;
var
  PostingOK : Boolean;
  OpenPicDlg: TOpenPictureDialog;
begin
  Result := True;
  OpenPicDlg := TOpenPictureDialog.Create(nil);

  If OpenPicDlg.Execute then begin
    Try
     PostingOK := False;
     if pBlobField.DataSet.State = dsBrowse then begin
       pBlobField.DataSet.Edit;
       PostingOK := True;
     end;

     If Blob_FromFile(pBlobField,OpenPicDlg.FileName) < 0 then
     begin
       Result := False;
       If PostingOK then
          pBlobField.DataSet.Cancel;
     end
     else
       If PostingOK then
         pBlobField.DataSet.Post;
    except
      Result := False;
    end;
  end;
  OpenPicDlg.Free;
end;

function Blob_ToFileImage(pBlobField:TField):boolean;
var
  SavePicDlg : TSavePictureDialog;
begin
  Result := True;
  SavePicDlg := TSavePictureDialog.Create(nil);
  If SavePicDlg.Execute then begin
    Try
      Result := Blob_ToFile(pBlobField,SavePicDlg.FileName) > 0 ;
    except
      Result := False;
    end;
  end;
  SavePicDlg.Free;  
end;

function Blob_Clear(pBlobField:TField;msg:String):Boolean;
var
  PostingOK : Boolean;
begin
  Result := True; 
  if MessageBox(0,PChar(msg), 'Perhatian',
    MB_OKCANCEL + MB_ICONWARNING + MB_DEFBUTTON2) = IDOK then
  begin
     try
       PostingOK := False;
       if pBlobField.DataSet.State = dsBrowse then begin
         pBlobField.DataSet.Edit;
         PostingOK := True;
       end;
       pBlobField.Clear;

       If PostingOK then
         pBlobField.DataSet.Post;
      except
        Result := False;
      end;     
  end;
End;


end.
