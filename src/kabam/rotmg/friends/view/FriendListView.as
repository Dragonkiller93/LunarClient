package kabam.rotmg.friends.view {
import com.company.assembleegameclient.account.ui.TextInputField;
import com.company.assembleegameclient.ui.DeprecatedTextButton;
import com.company.assembleegameclient.ui.dialogs.DialogCloser;
import com.company.ui.BaseSimpleText;
import com.company.util.GraphicsUtil;
import com.company.assembleegameclient.objects.Player;

import flash.display.CapsStyle;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormatAlign;
import flash.filters.DropShadowFilter;

import kabam.rotmg.friends.model.FriendConstant;
import kabam.rotmg.friends.model.FriendVO;
import kabam.rotmg.pets.util.PetsViewAssetFactory;
import kabam.rotmg.pets.view.components.DialogCloseButton;
import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

import org.osflash.signals.Signal;

public class FriendListView extends Sprite implements DialogCloser {

    public static const TEXT_WIDTH:int = 500;
    public static const TEXT_HEIGHT:int = 500;
    public static const LIST_ITEM_WIDTH:int = 490;
    public static const LIST_ITEM_HEIGHT:int = 40;
    private var player_:Player;
    private const closeButton:DialogCloseButton = PetsViewAssetFactory.returnCloseButton(TEXT_WIDTH);
    public var closeDialogSignal:Signal;
    public var actionSignal;
    public var tabSignal;
    private var title:TextFieldDisplayConcrete;
    public var _tabView:FriendTabView;
    public var _w:int;
    public var _h:int;
    private var _friendTotalText:TextFieldDisplayConcrete;
    private var _friendDefaultText:TextFieldDisplayConcrete;
    private var _inviteDefaultText:TextFieldDisplayConcrete;
    private var _addButton:DeprecatedTextButton;
    private var _findButton:DeprecatedTextButton;
    private var _nameInput:TextInputField;
    private var _friendsContainer:FriendListContainer;
    private var _invitationsContainer:FriendListContainer;
    private var _currentServerName:String;
    private var backgroundFill_:GraphicsSolidFill = new GraphicsSolidFill(0x333333, 1);
    private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(0xFFFFFF, 1);
    private var lineStyle_:GraphicsStroke = new GraphicsStroke(
            2, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, outlineFill_
    );
    private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
    private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[
        lineStyle_, backgroundFill_, path_, GraphicsUtil.END_FILL, GraphicsUtil.END_STROKE
    ];

    public function FriendListView(player_:Player) {
        this.closeDialogSignal = new Signal();
        this.actionSignal = new Signal(String, String);
        this.tabSignal = new Signal(String);
        this.player_=player_;

        super();

        this.init();
    }

    public function init():void {
        if(this.player_.subclass==-1){
            this.drawChooseClass();
        }
        else{

        }
        this.closeButton.addEventListener(MouseEvent.CLICK,this.onRemovedFromStage);
        this.closeButton.x =  780;
        addChild(closeButton);

    }

    public function destroy():void {
        while (numChildren > 0) {
            this.removeChildAt((numChildren - 1));
        }
        this.title = null;
    }

    public function updateFriendTab(_arg_1:Vector.<FriendVO>, _arg_2:String):void {
        var _local_3:FriendVO;
        var _local_4:FListItem;
        var _local_5:int;
        this._friendDefaultText.visible = (_arg_1.length <= 0);
        _local_5 = (this._friendsContainer.getTotal() - _arg_1.length);
        while (_local_5 > 0) {
            this._friendsContainer.removeChildAt((this._friendsContainer.getTotal() - 1));
            _local_5--;
        }
        _local_5 = 0;
        while (_local_5 < this._friendsContainer.getTotal()) {
            _local_3 = _arg_1.pop();
            if (_local_3 != null) {
                _local_4 = (this._friendsContainer.getChildAt(_local_5) as FListItem);
                _local_4.update(_local_3, _arg_2);
            }
            _local_5++;
        }
        for each (_local_3 in _arg_1) {
            _local_4 = new FriendListItem(_local_3, LIST_ITEM_WIDTH, LIST_ITEM_HEIGHT, _arg_2);
            _local_4.actionSignal.add(this.onListItemAction);
            _local_4.x = 2;
            this._friendsContainer.addListItem(_local_4);
        }
        _arg_1.length = 0;
        _arg_1 = null;
    }

    public function updateInvitationTab(_arg_1:Vector.<FriendVO>):void {
        var _local_2:FriendVO;
        var _local_3:FListItem;
        var _local_4:int;
        this._tabView.showTabBadget(1, _arg_1.length);
        this._inviteDefaultText.visible = (_arg_1.length == 0);
        _local_4 = (this._invitationsContainer.getTotal() - _arg_1.length);
        while (_local_4 > 0) {
            this._invitationsContainer.removeChildAt((this._invitationsContainer.getTotal() - 1));
            _local_4--;
        }
        _local_4 = 0;
        while (_local_4 < this._invitationsContainer.getTotal()) {
            _local_2 = _arg_1.pop();
            if (_local_2 != null) {
                _local_3 = (this._invitationsContainer.getChildAt(_local_4) as FListItem);
                _local_3.update(_local_2, "");
            }
            _local_4++;
        }
        for each (_local_2 in _arg_1) {
            _local_3 = new InvitationListItem(_local_2, LIST_ITEM_WIDTH, LIST_ITEM_HEIGHT);
            _local_3.actionSignal.add(this.onListItemAction);
            this._invitationsContainer.addListItem(_local_3);
        }
        _arg_1.length = 0;
        _arg_1 = null;
    }

    public function getCloseSignal():Signal {
        return (this.closeDialogSignal);
    }

    public function updateInput(_arg_1:String, _arg_2:Object = null):void {
        this._nameInput.setError(_arg_1, _arg_2);
    }

    private function onFocusIn(_arg_1:FocusEvent):void {
        this._nameInput.clearText();
        this._nameInput.clearError();
        this.actionSignal.dispatch(FriendConstant.SEARCH, this._nameInput.text());
    }


    private function onListItemAction(_arg_1:String, _arg_2:String):void {
        this.actionSignal.dispatch(_arg_1, _arg_2);
    }

    private function onRemovedFromStage(_arg_1:Event):void {
        removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        this.destroy();
    }

    private function drawBackground():void {



    }
    private function drawChooseClass():void{
        graphics.clear();
        graphics.beginFill(0x000000, 0.8);
        graphics.drawRect(0, 0, 800, 600);
        graphics.endFill();
        graphics.lineStyle(1, 0x5E5E5E);
        graphics.moveTo(0, 50);
        graphics.lineTo(800, 50);
        graphics.lineStyle();
        this.title = new TextFieldDisplayConcrete();
        this.title.setSize(18).setColor(0xFFFFFF).setTextWidth(150);
        this.title.setBold(true).setWordWrap(true).setMultiLine(true).setHorizontalAlign(TextFormatAlign.CENTER);
        this.title.textField= new TextField();
        this.title.setStringBuilder(new LineBuilder().setParams("Choose a class!"));
        this.title.filters = [new DropShadowFilter(0, 0, 0)];
        this.title.x = 310;
        this.title.y = 10;
        this.title.addChild(this.title.textField);
        this.addChild(title);
        graphics.lineStyle(1,0xFFFFFF);
        graphics.moveTo(200,50);
        graphics.lineTo(200,600);
        graphics.lineStyle();
        graphics.lineStyle(1,0xFFFFFF);
        graphics.moveTo(400,50);
        graphics.lineTo(400,600);
        graphics.lineStyle();
        graphics.lineStyle(1,0xFFFFFF);
        graphics.moveTo(600,50);
        graphics.lineTo(600,600);
        graphics.lineStyle();
        graphics.lineStyle(1,0xFFFFFF);
        graphics.moveTo(0,325);
        graphics.lineTo(800,325);
        graphics.lineStyle();
    }


}
}//package kabam.rotmg.friends.view
