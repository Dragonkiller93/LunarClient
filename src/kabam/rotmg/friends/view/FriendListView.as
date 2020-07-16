package kabam.rotmg.friends.view {
import com.company.assembleegameclient.account.ui.TextInputField;
import com.company.assembleegameclient.ui.DeprecatedTextButton;
import com.company.assembleegameclient.ui.TextButton;
import com.company.assembleegameclient.ui.dialogs.DialogCloser;
import com.company.ui.BaseSimpleText;
import com.company.util.AssetLibrary;
import com.company.util.GraphicsUtil;
import com.company.assembleegameclient.objects.Player;

import flash.display.Bitmap;

import flash.display.BitmapData;

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

import mx.core.Container;

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
    private var subclassdisplay:Sprite = new Sprite();
    private var skilltreedisplay:Sprite = new Sprite();
    private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
    private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[
        lineStyle_, backgroundFill_, path_, GraphicsUtil.END_FILL, GraphicsUtil.END_STROKE
    ];

    public function FriendListView(player_:Player) {
        this.closeDialogSignal = new Signal();
        this.actionSignal = new Signal(String, String);
        this.tabSignal = new Signal(String);
        this.player_ = player_;

        super();

        this.init();
    }

    public function init():void {
        if (this.player_.subclass == -1) {
            this.drawChooseClass();
            this.addChild(subclassdisplay);
        } else {
            this.drawSkillTree();
            this.addChild(skilltreedisplay);
        }
        this.closeButton.addEventListener(MouseEvent.CLICK, this.onRemovedFromStage);
        this.closeButton.x = 780;
        addChild(closeButton);

    }

    public function destroy():void {
        while (numChildren > 0) {
            this.removeChildAt((numChildren - 1));
        }
        this.title = null;
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
    private function EmptyFeats():Vector.<Boolean>{
        var result:Vector.<Boolean>= new Vector.<Boolean>();
        for(var i:int =0;i < 28;i++) {
            result.push(false);
        }
        return result;
    }
    private function ClasstoTree():void{
        this.removeChild(subclassdisplay);
        this.drawSkillTree();
        this.addChild(skilltreedisplay);
    }
    private function chooseClass1(_arg_1:Event):void {
        this.player_.subclass = 1;
        this.player_.map_.gs_.gsc_.changeSubClass(1,EmptyFeats());
        this.ClasstoTree();
    }
    private function chooseClass2(_arg_1:Event):void {
        this.player_.subclass = 2;
        this.player_.map_.gs_.gsc_.changeSubClass(2,EmptyFeats());
        this.ClasstoTree();
    }
    private function chooseClass3(_arg_1:Event):void {
        this.player_.subclass = 3;
        this.player_.map_.gs_.gsc_.changeSubClass(3,EmptyFeats());
        this.ClasstoTree();
    }
    private function chooseClass4(_arg_1:Event):void {
        this.player_.subclass = 4;
        this.player_.map_.gs_.gsc_.changeSubClass(4,EmptyFeats());
        this.ClasstoTree();
    }

    private function drawChooseClass():void {
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
        this.title.textField = new TextField();
        this.title.setStringBuilder(new LineBuilder().setParams("Choose a class!"));
        this.title.filters = [new DropShadowFilter(0, 0, 0)];
        this.title.x = 310;
        this.title.y = 10;
        this.title.addChild(this.title.textField);
        this.subclassdisplay.addChild(title);
        graphics.lineStyle(1, 0xFFFFFF);
        graphics.moveTo(200, 50);
        graphics.lineTo(200, 600);
        graphics.lineStyle();
        graphics.lineStyle(1, 0xFFFFFF);
        graphics.moveTo(400, 50);
        graphics.lineTo(400, 600);
        graphics.lineStyle();
        graphics.lineStyle(1, 0xFFFFFF);
        graphics.moveTo(600, 50);
        graphics.lineTo(600, 600);
        graphics.lineStyle();
        var class_1:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
        var class_2:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
        var class_3:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
        var class_4:TextFieldDisplayConcrete = new TextFieldDisplayConcrete();
        var classes:Vector.<TextFieldDisplayConcrete> = new Vector.<TextFieldDisplayConcrete>();
        var buttons:Vector.<TextButton> = new Vector.<TextButton>();
        var button_1:TextButton = new TextButton(12, "Select", 0);
        var button_2:TextButton = new TextButton(12, "Select", 0);
        var button_3:TextButton = new TextButton(12, "Select", 0);
        var button_4:TextButton = new TextButton(12, "Select", 0);
        classes.push(class_1);
        classes.push(class_2);
        classes.push(class_3);
        classes.push(class_4);
        buttons.push(button_1);
        buttons.push(button_2);
        buttons.push(button_3);
        buttons.push(button_4);

        //class 1 stuff
        class_1.setStringBuilder(new LineBuilder().setParams("Magi"));
        class_1.x = 50;
        class_1.y = 80;

        //button 1 stuff
        button_1.x=70;
        button_1.y=530;
        button_1.changeColor(0x000000);
        button_1.addEventListener(MouseEvent.CLICK,chooseClass1);
        
        //class 2 stuff
        class_2.setStringBuilder(new LineBuilder().setParams("Battle Master"));
        class_2.x = 280;
        class_2.y = 80;

        //button 2 stuff
        button_2.x=270;
        button_2.y=530;
        button_2.changeColor(0x000000);
        button_2.addEventListener(MouseEvent.CLICK,chooseClass2);
        
        //class 3 stuff
        class_3.setStringBuilder(new LineBuilder().setParams("Juggernaut"));
        class_3.x = 450;
        class_3.y = 80;
        
        //button 3 stuff
        button_3.x=470;
        button_3.y=530;
        button_3.changeColor(0x000000);
        button_3.addEventListener(MouseEvent.CLICK,chooseClass3);

        //class 4 stuff
        class_4.setStringBuilder(new LineBuilder().setParams("Thief"));
        class_4.x = 680;
        class_4.y = 80;

        //button 4 stuff
        button_4.x=670;
        button_4.y=530;
        button_4.changeColor(0x000000);
        button_4.addEventListener(MouseEvent.CLICK,chooseClass4);

        for each(var subclass:TextFieldDisplayConcrete in classes) {
            subclass.setSize(18).setColor(0xFFFFFF).setTextWidth(150);
            this.subclassdisplay.addChild(subclass);
        }
        for each(var button:TextButton in buttons) {
            this.subclassdisplay.addChild(button);

        }


    }
    private function canChoose(column:int, featindex:int) {
        var class1feats = player_.feats.splice(0, 7);
        var class2feats = player_.feats.splice(0, 7);
        var class3feats = player_.feats.splice(0, 7);
        var class4feats = player_.feats;
        player_.feats = class1feats.concat(class2feats).concat(class3feats).concat(class4feats);
        var subclass:int = player_.subclass;

        switch (column) {
            case 1:
                return ((featindex > 0 && class1feats[featindex - 1]) || (featindex == 0 && subclass == 1) || (featindex > 1 && class2feats[featindex - 2]) || (featindex==1 && subclass==2) );
            case 2:
                return ((featindex > 0 && class2feats[featindex - 1]) || (featindex == 0 && subclass == 2) || (featindex < 5 && class1feats[featindex + 2]) || (featindex > 0 && class3feats[featindex - 1]) || (featindex==0 && subclass==3));
            case 3:
                return ((featindex > 0 && class3feats[featindex - 1]) || (featindex == 0 && subclass == 3) || (featindex < 6 && class2feats[featindex + 1]) || (featindex < 3 && class4feats[featindex + 4]));
            case 4:
                return ((featindex > 0 && class4feats[featindex - 1]) || (featindex == 0 && subclass == 4) || (featindex > 3 && class3feats[featindex - 4]) || (featindex==3 && subclass==3));
        }
    }
    private function drawSkillTree():void{
        graphics.beginFill(0x6a6a6a, 1);
        graphics.drawRect(0, 0, 800, 600);
        graphics.beginFill(0x000000,0.8);
        graphics.drawRect(100,0,600,600);

        var vertDistance:int = 12;
        var horDistance:int = 100;
        var startingX:int = 200;
        var startingY:int=520;
        var subclassScale:Number = 1.8;
        var featScale:Number = 1.2;
        var featLength:int = featScale*32;
        var subclasslength:int = subclassScale*32;
        

        var class1feats = player_.feats.splice(0,7);
        var class2feats = player_.feats.splice(0,7);
        var class3feats = player_.feats.splice(0,7);
        var class4feats = player_.feats;
        player_.feats = class1feats.concat(class2feats).concat(class3feats).concat(class4feats);
        var subclass:int = player_.subclass;
        //Subclass 1
        var class1data:BitmapData = AssetLibrary.getImageFromSet("LunarSkillIcons", 0x00);
        var class1:Bitmap = new Bitmap(class1data);
        class1.x=startingX;
        class1.y=startingY;
        class1.scaleX=subclassScale;
        class1.scaleY=subclassScale;

        var c1fs:Vector.<Bitmap> = new Vector.<Bitmap>(7);
        for(var i:int = 0;i < c1fs.length;i++){
            var temp:Bitmap =new Bitmap(AssetLibrary.getImageFromSet("LunarSkillIcons",0x01+i));
            temp.x = class1.x+((subclasslength-featLength)/2);
            temp.y = class1.y-featLength-vertDistance-((featLength+vertDistance)*i);
            temp.scaleX = featScale;
            temp.scaleY = featScale;
            temp.alpha = canChoose(1,i)?1:0.4;
            c1fs[i] = temp;
        }
        

        //Subclass 2
        var class2data:BitmapData = AssetLibrary.getImageFromSet("LunarSkillIcons", 0x10);
        var class2:Bitmap = new Bitmap(class2data);
        class2.x=startingX+(featLength+horDistance);
        class2.y=startingY-(featLength+vertDistance)*2;
        class2.scaleX=subclassScale;
        class2.scaleY=subclassScale;

        var c2fs:Vector.<Bitmap> = new Vector.<Bitmap>(7);
        for(var i:int = 0;i < c2fs.length;i++){
            var temp:Bitmap = new Bitmap(AssetLibrary.getImageFromSet("LunarSkillIcons",0x11+i));
            temp.x = class2.x+((subclasslength-featLength)/2);
            temp.y = class2.y-featLength-vertDistance-((featLength+vertDistance)*i);
            temp.scaleX = featScale;
            temp.scaleY = featScale;
            temp.alpha = canChoose(2,i)?1:0.4;
            c2fs[i] = temp;
        }


        //Subclass 3
        var class3data:BitmapData = AssetLibrary.getImageFromSet("LunarSkillIcons", 0x20);
        var class3:Bitmap = new Bitmap(class3data);
        class3.x=startingX + (featLength+horDistance)*2;
        class3.y=startingY-(featLength+vertDistance)*3;
        class3.scaleX=subclassScale;
        class3.scaleY=subclassScale;

        var c3fs:Vector.<Bitmap> = new Vector.<Bitmap>(7);
        for(var i:int = 0;i < c3fs.length;i++){
            var temp:Bitmap = new Bitmap(AssetLibrary.getImageFromSet("LunarSkillIcons",0x21+i));
            temp.x = class3.x+((subclasslength-featLength)/2);
            temp.y = class3.y-featLength-vertDistance-((featLength+vertDistance)*i);
            temp.scaleX = featScale;
            temp.scaleY = featScale;
            temp.alpha = canChoose(3,i)?1:0.4;
            c3fs[i] = temp;
        }


        //Subclass 4
        var class4data:BitmapData = AssetLibrary.getImageFromSet("LunarSkillIcons", 0x30);
        var class4:Bitmap = new Bitmap(class4data);
        class4.x=startingX+(featLength+horDistance)*3;
        class4.y=startingY+(featLength+vertDistance);
        class4.scaleX=subclassScale;
        class4.scaleY=subclassScale;

        var c4fs:Vector.<Bitmap> = new Vector.<Bitmap>(7);
        for(var i:int = 0;i < c4fs.length;i++){
            var temp:Bitmap = new Bitmap(AssetLibrary.getImageFromSet("LunarSkillIcons",0x31+i));
            temp.x = class4.x+((subclasslength-featLength)/2);
            temp.y = class4.y-featLength-vertDistance-((featLength+vertDistance)*i);
            temp.scaleX = featScale;
            temp.scaleY = featScale;
            temp.alpha = canChoose(4,i)?1:0.4;
            c4fs[i]=temp;

        }
        



        var subclassicons:Vector.<Bitmap> = new <Bitmap>[class1,class2,class3,class4];
        var feats:Vector.<Bitmap>= c1fs.concat(c2fs).concat(c3fs).concat(c4fs);
        for each(var b:Bitmap in feats){
            skilltreedisplay.addChild(b);
        }
        skilltreedisplay.addChild(subclassicons[subclass-1]);
    }
}//package kabam.rotmg.friends.view
}