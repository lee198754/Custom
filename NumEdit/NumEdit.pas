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
  inherited; //继承父类 Tedit 的响应
  //delaexit () ; //处理控件内容
end;

constructor TNumEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMin := 0; //最小值默认为 0
  FMax := 255; //最大值默认为 255
  Fdotnum:=2; //小数点个数默认为 2 个
  Text := '0' ;
  //text 继承自 Tedit，设置默认显示为 0.00
end;

procedure TNumEdit.KeyPress(var Key: Char);
begin
  inherited
  KeyPress (Key) ; //继承父类
  if key in [#13] then
  //如果按回车键，处理控件内容
  //delaexit;
  If not (key in [#45,#46,#48..#57,#8]) then
  //如果非数字键，不响应
  begin
    key:= #0;
    //该语句使你按键时候，控件不予处理、不显示
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

