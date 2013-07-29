unit NumEdit;

interface

uses
  SysUtils, Classes, Controls, StdCtrls;

type
  TNumEdit = class(TEdit)
  private
    FMin: Extended;
    FMax: Extended;
    Fdotnum:Cardinal;
    procedure CMExit(var Message: TCMExit); message cm_exit;
    { Private declarations }
  protected
    { Protected declarations }
    procedure  KeyPress(var Key: Char); override;
    procedure SetMin (value: Extended) ;
    procedure SetMax (value: Extended) ;
    procedure setdotnum (value: Cardinal) ;
  public
    { Public declarations }
    constructor Create (AOwner: TComponent) ; override;
  published
    { Published declarations }
    property Min: Extended read FMin write SetMin;
    property Max: Extended read FMax write SetMax;
    property dotnum:Cardinal read Fdotnum write setdotnum;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('My', [TNumEdit]);
end;

{ TNumEdit1 }

procedure TNumEdit.CMExit(var Message: TCMExit);
begin
  inherited; //�̳и��� Tedit ����Ӧ
  //delaexit () ; //����ؼ�����
end;

constructor TNumEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMin := 0; //��СֵĬ��Ϊ 0
  FMax := 255; //���ֵĬ��Ϊ 255
  Fdotnum:=2; //С�������Ĭ��Ϊ 2 ��
  Text := '0' ;
  //text �̳��� Tedit������Ĭ����ʾΪ 0.00
end;

procedure TNumEdit.KeyPress(var Key: Char);
begin
  inherited
  KeyPress (Key) ; //�̳и���
  if key in [#13] then
  //������س���������ؼ�����
  //delaexit;
  If not (key in [#45,#46,#48..#57,#8]) then
  //��������ּ�������Ӧ
  begin
    key:= #0;
    //�����ʹ�㰴��ʱ�򣬿ؼ����账������ʾ
  end;
end;

procedure TNumEdit.setdotnum(value: Cardinal);
begin
  Fdotnum:=value;
  Text := '0'
end;

procedure TNumEdit.SetMax(value: Extended);
begin
  FMax := value;
  if FMin > FMax then
    FMin := FMax;
end;

procedure TNumEdit.SetMin(value: Extended);
begin
  FMin := value;
  if FMax < FMin then
    FMax := FMin;
end;

end.

