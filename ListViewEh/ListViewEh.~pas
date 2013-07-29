unit ListViewEh;

interface

uses
  SysUtils, Classes, Controls, ComCtrls,Types,Graphics, CommCtrl,Windows,ImgList;

type
  TCustomListViewEh = class;

  TOptionsEh = class(TPersistent)
  private
    FCustomListViewEh: TCustomListViewEh;
    FRowHight: Integer;
    FRowColorOne: TColor;
    FRowColorSec: TColor;
    procedure SetRowHight(const Value: Integer);
    procedure SetRowColorOne(const Value: TColor);
    procedure SetRowColorSec(const Value: TColor);
  public
    constructor Create(AOwner: TCustomListViewEh);
  published
     property RowHight: Integer read FRowHight write SetRowHight default 20;
     property RowColorOne: TColor read FRowColorOne write SetRowColorOne default $00F0FFF0;
     property RowColorSec: TColor read FRowColorSec write SetRowColorSec default $00F2F2F2;
  end;

  TSort = (srtAce,srtDesc);
  PColSort = ^TColSort;
  TColSort = record
    m_ColIndex: Integer;
    m_Sort: TSort;
  end;

  TCustomListViewEh = class(TListView)
  private
    { Private declarations }
    FColSort: PColSort;
    FSmallImages: TCustomImageList;
    FOptionsEh: TOptionsEh;
    procedure LVDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure SetOptionsEh(const Value: TOptionsEh);
  protected
    { Protected declarations }
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure ColClick(Column: TListColumn); override;
    procedure Click;override;
    function CustomDrawItem(Item: TListItem; State: TCustomDrawState;
      Stage: TCustomDrawStage): Boolean; override;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
    property SmallImages;
    property ViewStyle default vsReport;
    property RowSelect default True;
    property ReadOnly default True;
    property OptionsEh: TOptionsEh  read FOptionsEh write SetOptionsEh;
  end;

  TListViewEh = class(TCustomListViewEh)

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('My', [TListViewEh]);
end;

{ TListViewEh }
var
  pSort: PColSort;      //必须用全局变量才能被局部函数RzCustomSortProc调用


procedure TCustomListViewEh.Click;
begin
  inherited;

end;

procedure TCustomListViewEh.ColClick(Column: TListColumn);

  function RzCustomSortProc( Item1, Item2, ColIndex: Integer): Integer; stdcall;
  var
    Item1Str: string;
    Item2Str: string;
    ListItem1, ListItem2: TListItem;
    ColSort: PColSort;
  begin
    Result := 0;
    New(ColSort);
    ColSort.m_ColIndex := fcolsort.m_ColIndex;
    ColSort.m_Sort :=fcolsort.m_Sort;
    ListItem1 := TListItem( Item1 );
    ListItem2 := TListItem( Item2 );
    if ( ListItem1 = nil ) or ( ListItem2 = nil ) then
      Exit;

    Item1Str := '';
    Item2Str := '';

    if ColIndex < 0 then
      Exit;

    if ColIndex = 0 then
    begin
      Item1Str := ListItem1.Caption;
      Item2Str := ListItem2.Caption;
    end
    else
    begin
      if ColIndex <= ListItem1.SubItems.Count then
        Item1Str := ListItem1.SubItems[ ColIndex - 1 ];

      if ColIndex <= ListItem2.SubItems.Count then
        Item2Str := ListItem2.SubItems[ ColIndex - 1 ];

    end;

    Result := CompareText( Item1Str, Item2Str );

    // If one of the strings is empty, make the other string sort before it

    if ( Result > 0 ) and ( Item2Str = '' ) then
      Result := -1
    else if ( Result < 0 ) and ( Item1Str = '' ) then
      Result := 1;

    if  (ColSort.m_ColIndex =ColIndex) and (ColSort.m_Sort = srtAce) then  //排序状态是排列前的状态
    begin
      Result := -Result;
    end;
  end; {= RzCustomSortProc =}
var
  i: Integer;
  bQx: Boolean;
begin
  inherited;
  if (Checkboxes) and (Column.Index = 0) then
  begin
    bQx := False;
    for i := 0 to Items.Count -1 do
    begin
      if not Items[i].Checked then
      begin
        bQx := True;
        Break
      end;
    end;
    for i := 0 to Items.Count -1 do
      Items[i].Checked := bQx;
  end else
  begin
    if not Assigned(FColSort) then
    begin
      New(FColSort);
      pSort := FColSort;
      //FColSort.m_ColIndex := -1;
      //FColSort.m_Sort := srtACE;
    end;
    if FColSort.m_ColIndex = Column.Index then
    begin
      if FColSort.m_Sort = srtAce then
      begin
        if CustomSort(@RzCustomSortProc,Column.Index) then
        begin
          FColSort.m_Sort := srtDesc;
        end;
      end else
      if FColSort.m_Sort = srtDesc then
      begin
        if CustomSort(@RzCustomSortProc,Column.Index) then
        begin
          FColSort.m_Sort := srtAce;
        end;
      end;
    end else
    begin
      if CustomSort(@RzCustomSortProc,Column.Index) then
      begin
        FColSort.m_ColIndex := Column.Index;
        FColSort.m_Sort := srtAce;
      end;
    end;      

  end;

end;

constructor TCustomListViewEh.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOptionsEh := TOptionsEH.Create(Self);
  FSmallImages := TImageList.Create(Self);
  SmallImages := FSmallImages;
  SmallImages.Height := OptionsEH.RowHight;
  ViewStyle := vsReport;
  RowSelect := True;
  ReadOnly := True;
  OnCustomDrawItem := LVDrawItem; //绑定OnCustomDrawItem方法
end;



function TCustomListViewEh.CustomDrawItem(Item: TListItem;
  State: TCustomDrawState; Stage: TCustomDrawStage): Boolean;
var
  fLVDrawItem: TLVCustomDrawItemEvent;
begin
  fLVDrawItem := LVDrawItem;
  if @fLVDrawItem <> @OnCustomDrawItem then
    inherited CustomDrawItem(Item,State,Stage);
  LVDrawItem(TCustomListView(Self),Item,State,Result);
end;

procedure TCustomListViewEh.LVDrawItem(Sender: TCustomListView; Item: TListItem;
  State: TCustomDrawState; var DefaultDraw: Boolean);
var
  BoundRect, Rect: TRect;
  i: integer;
  TextFormat: Word;
  LV: TListView;
  procedure Draw_CheckBox_ImageList(r: TRect; aCanvas: TCanvas; Checked: Boolean);
  var
    R1: TRect;
  begin
    if Sender.Checkboxes then
    begin
      aCanvas.Pen.Color := clBlack;
      aCanvas.Pen.Width := 1;
      //画CheckBox外框

      aCanvas.Rectangle(r.Left + 4, r.Top + 5, r.Left + 14, r.Bottom - 5);
      if Checked then
      begin //画CheckBox的勾
        aCanvas.Pen.Color := clRed;
        aCanvas.Pen.Width := 2;
        aCanvas.MoveTo(r.Left + 6, r.Top + 8);
        aCanvas.LineTo(r.Left + 8, r.Top + 13);
        aCanvas.LineTo(r.Left + 18, r.Top + 4);
        aCanvas.Pen.Width := 1;
        aCanvas.Pen.Color := clBlack;
      end;
      aCanvas.Pen.Width := 1;
    end;
    //开始画图标
    if (Item.ImageIndex > -1)and(LV.SmallImages <>nil) then
    begin
    //获取图标的RECT
      if Boolean(ListView_GetSubItemRect(sender.Handle, item.Index, 0, LVIR_ICON, @R1)) then
      begin
        LV.SmallImages.Draw(LV.Canvas, R1.Left, R1.Top, Item.ImageIndex);
      end;
    end;
  end;
begin
  LV := TListView(Sender);
  //设置隔行背景颜色
  if (Item.Index mod 2) = 0 then
    Self.Canvas.Brush.Color := OptionsEH.RowColorOne
  else
    Self.Canvas.Brush.Color := OptionsEH.RowColorSec;

  BoundRect := Item.DisplayRect(drBounds);
  InflateRect(BoundRect, -1, 0);
  if Item.Selected then
  begin
    if cdsFocused in State then
    begin
      LV.Canvas.Brush.Color := $00ECCCB9; //  //clHighlight;
     // LV.Canvas.Font.Color := clBtnText; //clHighlightText;
    end
    else
    begin
      LV.Canvas.Brush.Color := $00F8ECE5; //clSilver;
      //LV.Canvas.Font.Color := clBtnText;
    end;
  end
  else
  begin
    //LV.Canvas.Brush.Color := clWindow;
    //LV.Canvas.Font.Color := clWindowText;
  end;

  LV.Canvas.FillRect(BoundRect); //初始化背景
 
  for i := 0 to LV.Columns.Count - 1 do
  begin
  //获取SubItem的Rect
    ListView_GetSubItemRect(LV.Handle, Item.Index, i, LVIR_LABEL, @Rect);
    case LV.Columns[i].Alignment of
      taLeftJustify:
        TextFormat := 0;
      taRightJustify:
        TextFormat := DT_RIGHT;
      taCenter:
        TextFormat := DT_CENTER;
    else
      TextFormat := 0;
    end;
    case i of
      0: //画Caption
        begin
          Draw_CheckBox_ImageList(BoundRect, LV.Canvas, Item.Checked);

          InflateRect(Rect,-3, 0); //向后移3个像素,避免被后面画线框时覆盖
          DrawText(
            LV.Canvas.Handle,
            PCHAR(Item.Caption),
            Length(Item.Caption),
            Rect,
            DT_VCENTER or DT_SINGLELINE or DT_END_ELLIPSIS or TextFormat);
        end;
      1..MaxInt: //画Subitems[i]
        begin
          if i - 1 <= Item.SubItems.Count - 1 then
            DrawText(
              LV.Canvas.Handle,
              PCHAR(Item.SubItems[i - 1]),
              Length(Item.SubItems[i - 1]),
              Rect,
              DT_VCENTER or DT_SINGLELINE or DT_END_ELLIPSIS or TextFormat);
        end;
    end;
 
  end;
 

  //LV.Canvas.Brush.Color := clWhite;
 
  if Item.Selected then //画选中条外框
  begin
    if cdsFocused in State then
      LV.Canvas.Brush.Color := $00DAA07A // $00E2B598; //clHighlight;
    else
      LV.Canvas.Brush.Color :=$00E2B598; //$00DAA07A // clHighlight;
    LV.Canvas.FrameRect(BoundRect); // DrawFocusRect(Item.DisplayRect(drBounds)); //
  end;

  DefaultDraw := False; //True;//cdsSelected in State;
 
  with Sender.Canvas do
    if Assigned(Font.OnChange) then Font.OnChange(Font);

end;


procedure TCustomListViewEh.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  BoundRect: TRect;
begin
  inherited;
  if (Checkboxes) and (RowSelect) then
  begin
    if Assigned(GetItemAt(X,Y)) then
    begin
      BoundRect := GetItemAt(X,Y).DisplayRect(drBounds);
      if (X <=  BoundRect.Left+14) then
      begin
        ItemIndex := GetItemAt(X,Y).Index;
      end;
      if (Button = mbleft) and (X > BoundRect.Left+14) then
      begin
        Selected.Checked := not Selected.Checked;
      end;
    end;
  end;
end;

procedure TCustomListViewEh.SetOptionsEH(const Value: TOptionsEh);
begin
  with FOptionsEH do
  begin
    RowHight := Value.RowHight;
    RowColorOne := Value.RowColorOne;
    RowColorSec := Value.RowColorSec;
  end;
end;

{ TOptionsEH }

constructor TOptionsEh.Create(AOwner: TCustomListViewEh);
begin
  inherited Create;
  FCustomListViewEh := AOwner;
  FRowHight := 20;
  FRowColorOne :=  $00F0FFF0;
  FRowColorSec :=  $00F2F2F2;

end;

procedure TOptionsEh.SetRowColorOne(const Value: TColor);
begin
  FRowColorOne := Value;
end;

procedure TOptionsEH.SetRowHight(const Value: Integer);
begin
  if FRowHight <> Value then
  begin
    FRowHight := Value;
    FCustomListViewEh.FSmallImages.Height := FRowHight;
  end;
end;



procedure TOptionsEh.SetRowColorSec(const Value: TColor);
begin
  FRowColorSec := Value;
end;

end.
