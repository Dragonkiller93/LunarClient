﻿package kabam.rotmg.skilltree.view {
import com.company.assembleegameclient.account.ui.TextInputField;
import com.company.assembleegameclient.ui.DeprecatedTextButton;
import com.company.assembleegameclient.ui.TextButton;
import com.company.assembleegameclient.ui.dialogs.DialogCloser;
import com.company.assembleegameclient.ui.icons.IconButton;
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
import flash.geom.ColorTransform;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormatAlign;
import flash.filters.DropShadowFilter;

import kabam.rotmg.LunarSkillTree.SkillIcon;
import kabam.rotmg.LunarSkillTree.SkillLiterals;
import kabam.rotmg.LunarSkillTree.SkillLiterals;

import kabam.rotmg.pets.util.PetsViewAssetFactory;
import kabam.rotmg.pets.view.components.DialogCloseButton;
import kabam.rotmg.text.model.TextKey;
import kabam.rotmg.text.view.TextFieldDisplayConcrete;
import kabam.rotmg.text.view.stringBuilder.LineBuilder;

import mx.core.Container;

import org.osflash.signals.Signal;

public class SkillTreeView extends Sprite implements DialogCloser {

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
    private var _nameInput:TextInputField;
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

    public function SkillTreeView(player_:Player) {
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


    private function EmptyFeats():Vector.<Boolean>{
        var result:Vector.<Boolean>= new Vector.<Boolean>();
        for(var i:int =0;i < 40;i++) {
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
    private function reset(_arg_1:Event):void{
        this.player_.feats=EmptyFeats();
        this.removeChild(skilltreedisplay);
        this.drawChooseClass();
        this.addChild(subclassdisplay);
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
    private function canChoose(featindex:int) {
        if(player_.feats[featindex]) return true;
        for each(var i:int in SkillLiterals.getUnlocks(featindex)){
            if(i<0 && player_.subclass ==-1*i) return true;
            else if(i >= 0 && player_.feats[i]) return true;
        }
        return false;

    }
    public function ChooseFeat(index:int):Function{
        var currentfeats:int = 0;
        var f:FriendListView = this;
        for each(var b:Boolean in player_.feats) currentfeats+=b?1:0;
        if((currentfeats < (int) ((player_.level_-20)/3)) && canChoose(index)) {
            return function(_arg_1:MouseEvent):void {
                player_.feats[index] = true;
                player_.showEffectText(player_.feats.length.toString());
                player_.map_.gs_.gsc_.changeSubClass(player_.subclass,player_.feats);
                f.drawSkillTree();
            }
        }
        return function(_arg_1:MouseEvent):void{}
    }
    private function MeetsRequirements(index:int):Boolean {
        var req:Vector.<int> = SkillLiterals.specialReqs[index];
        if(req==null) return true;
        var numChosen:int = 0;
        for(var i:int =0; i < player_.feats.length;i++) {
            if(player_.feats[i] && SkillLiterals.getType(i)==req[0]) numChosen++;
        }
        return numChosen>=req[1];
    }
    private function drawSkillTree():void{
        while(skilltreedisplay.numChildren>0) {skilltreedisplay.removeChildAt(0);}
        graphics.lineStyle(1,0,0);
        graphics.beginFill(0x6a6a6a, 1);
        graphics.drawRect(0, 0, 800, 600);
        graphics.beginFill(0x000000,0.8);
        graphics.drawRect(100,0,600,600);

        var numClasses:int = 4;
        var Classes :Vector.<int> = new <int>[0,2,3,-1];
        var numFeats:Vector.<int> = new <int>[7,7,7,7];
        var subclass:int = player_.subclass-1;
        var feats:Vector.<Boolean> = player_.feats.slice();


        var vertDistance:int = 12;
        var horDistance:int = 100;
        var startingX:int = 200;
        var startingY:int=480;
        var subclassScale:Number = 1.4;
        var featScale:Number = 1;
        var featLength:Number = featScale*32;
        var subclasslength:Number = subclassScale*32;
        var featBorderWidth:int = 1;
        var subclassBorderWidth:int = 3;
        var featBorderColor:int = 0xFF0000;
        var subclassBorderColor:int = 0xFF0000;




        var classIcons:Vector.<SkillIcon> = new Vector.<SkillIcon>();
        var featIcons:Vector.<SkillIcon> = new Vector.<SkillIcon>();

        for (var i:int=0;i < numClasses;i++){
            var subclassX:int = startingX + ((featLength+horDistance)*i);
            var subclassY:int = startingY - ((featLength+vertDistance)*Classes[i]);
            var subclassIcon:SkillIcon = new SkillIcon(AssetLibrary.getImageFromSet("LunarSkillIcons",0x10*i));
            subclassIcon.x = subclassX;
            subclassIcon.y = subclassY;
            subclassIcon.setSize(subclasslength);
            subclassIcon.icon_.alpha=0.1;
            if(i == subclass){
                subclassIcon.icon_.alpha=1;
                graphics.lineStyle(subclassBorderWidth,subclassBorderColor);
                graphics.drawRect(subclassX-1,subclassY-1,subclasslength+2,subclasslength+2);
            }
            subclassIcon.setToolTipTitle(SkillLiterals.getSubclassName(i));
            subclassIcon.setToolTipText(SkillLiterals.getSubclassDescription(i));
            subclassIcon.toolTip_.tipText_.setSize(15);
            classIcons.push(subclassIcon);
            for(var j:int=0;j < numFeats[i];j++){
                var feat:SkillIcon = new SkillIcon(AssetLibrary.getImageFromSet("LunarSkillIcons",(0x10*i)+j+1));
                var featX:int = subclassX+((subclasslength-featLength)/2);
                var featY:int = subclassY-((featLength+vertDistance)*(j+1));
                var isChosen:Boolean = feats[featIcons.length];
                feat.x=featX;
                feat.y=featY;
                feat.setSize(featLength);
                feat.icon_.alpha = 0.1;
                if(canChoose(featIcons.length)){
                    feat.icon_.alpha=0.6;
                    feat.setToolTipTitle(SkillLiterals.getFeatName(featIcons.length));
                    feat.setToolTipText(SkillLiterals.getFeatDesc(featIcons.length));
                    switch(SkillLiterals.getType(featIcons.length)){
                        case 1:feat.setColor(0x0000cc); break;
                        case 2:feat.setColor(0xcc0000); break;
                        case 3:feat.setColor(0x351c75); break;
                        case 4:feat.setColor(0xf1c232); break;
                    }
                    if(isChosen){
                        feat.icon_.alpha=1;
                        graphics.lineStyle(featBorderWidth,featBorderColor);
                        graphics.drawRect(featX-1,featY-1,featLength+2,featLength+2);
                    }
                    else{
                        if(!MeetsRequirements(featIcons.length)){
                            var req:Vector.<int> = SkillLiterals.specialReqs[featIcons.length];
                            feat.setToolTipText("You Require: " + req[1]+ " skills in that group.");
                        }
                        else {
                            feat.addEventListener(MouseEvent.CLICK, ChooseFeat(featIcons.length));
                        }
                    }
                }


                featIcons.push(feat);

            }


        }
        for(i=0; i <SkillLiterals.specialFeatLocs.length;i++){
            var loc:Vector.<int> = SkillLiterals.specialFeatLocs[i];
            featX = startingX+((featLength+horDistance)*(loc[0]-.5) +(subclasslength-featLength)/2);
            featY = startingY-((featLength+vertDistance)*(loc[1]));
            feat= new SkillIcon(AssetLibrary.getImageFromSet("LunarSkillIcons",(0x40)+i));

            isChosen = feats[featIcons.length];
            feat.x=featX;
            feat.y=featY;
            feat.setSize(featLength);
            feat.icon_.alpha = 0.1;
            if(canChoose(featIcons.length)){
                feat.icon_.alpha=0.6;
                feat.setToolTipTitle(SkillLiterals.getFeatName(featIcons.length));
                feat.setToolTipText(SkillLiterals.getFeatDesc(featIcons.length));
                switch(SkillLiterals.getType(featIcons.length)){
                    case 1:feat.setColor(0x0000cc); break;
                    case 2:feat.setColor(0xcc0000); break;
                    case 3:feat.setColor(0x351c75); break;
                    case 4:feat.setColor(0xf1c232); break;
                }



                }
                if(isChosen){
                    feat.icon_.alpha=1;
                    graphics.lineStyle(featBorderWidth,featBorderColor);
                    graphics.drawRect(featX-1,featY-1,featLength+2,featLength+2);
                }
                else{
                    feat.addEventListener(MouseEvent.CLICK,ChooseFeat(featIcons.length));
                }
            featIcons.push(feat);
            }


        var resetButton:TextButton = new TextButton(12, "Reset", 0);
        resetButton.x=50;
        resetButton.y=300;
        resetButton.addEventListener(MouseEvent.CLICK,reset);
        skilltreedisplay.addChild(resetButton);
        for each(var icon:SkillIcon in classIcons.concat(featIcons)){
            skilltreedisplay.addChild(icon);
        }

    }
}
}