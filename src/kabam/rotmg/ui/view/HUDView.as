package kabam.rotmg.ui.view {
import com.company.assembleegameclient.game.AGameSprite;
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.map.AbstractMap;
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.objects.ImageFactory;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.TradePanel;
import com.company.assembleegameclient.ui.icons.IconButton;
import com.company.assembleegameclient.ui.icons.IconButtonFactory;
import com.company.assembleegameclient.ui.panels.InteractPanel;
import com.company.assembleegameclient.ui.panels.itemgrids.EquippedGrid;
import com.company.util.GraphicsUtil;
import com.company.util.SpriteUtil;

import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import kabam.rotmg.core.StaticInjectorContext;

import kabam.rotmg.dialogs.control.OpenDialogSignal;

import kabam.rotmg.friends.view.FriendListView;
import kabam.rotmg.game.model.GameInitData;
import kabam.rotmg.game.view.components.BackpackTabContent;
import kabam.rotmg.game.view.components.InventoryTabContent;
import kabam.rotmg.game.view.components.StatsTabContent;

import kabam.rotmg.game.view.components.TabStripView;
import kabam.rotmg.messaging.impl.incoming.File;
import kabam.rotmg.messaging.impl.incoming.TradeAccepted;
import kabam.rotmg.messaging.impl.incoming.TradeChanged;
import kabam.rotmg.messaging.impl.incoming.TradeStart;
import kabam.rotmg.minimap.view.MiniMapImp;

public class HUDView extends Sprite implements UnFocusAble {
    private const BG_POSITION:Point = new Point(0, 0);
    private const MAP_POSITION:Point = new Point(4, 4);
    private const CHARACTER_DETAIL_PANEL_POSITION:Point = new Point(0, 198);
    private const STAT_METERS_POSITION:Point = new Point(12, 230);
    private const EQUIPMENT_INVENTORY_POSITION:Point = new Point(14, 304);
    private const TAB_STRIP_POSITION:Point = new Point(7, 346);
    private const INTERACT_PANEL_POSITION:Point = new Point(0, 500);
    private const SKILL_TREE_BTN_POSITION:Point = new Point(140,202);

    private const tab1pos:Point = new Point(14,330);
    private const tab2pos:Point = new Point(14,470);
    private var tab1:int = 0;
    private var tab2:int = 0;



    private var background:CharacterWindowBackground;
    private var miniMap:MiniMapImp;
    public var equippedGrid:EquippedGrid;
    private var statMeters:StatMetersView;
    private var characterDetails:CharacterDetailsView;
    private var equippedGridBG:Sprite;
    private var player:Player;
    private var inventory:InventoryTabContent;
    private var stats:StatsTabContent;
    //public var tabStrip:TabStripView;
    public var interactPanel:InteractPanel;
    public var tradePanel:TradePanel;
    public var skillTreeBtn:IconButton;
    private var backpack:BackpackTabContent;
    private var toredraw:Boolean = false;
    private var tabButtons:Vector.<IconButton> = new Vector.<IconButton>(5);

    public function HUDView() {
        this.createAssets();
        this.addAssets();
        this.positionAssets();
        this.addButtons();
        this.redraw();
    }
    private function createAssets():void {
        this.background = new CharacterWindowBackground();
        this.miniMap = new MiniMapImp(192, 192);
        //this.tabStrip = new TabStripView();
        this.characterDetails = new CharacterDetailsView(this);
        this.statMeters = new StatMetersView();
        createSkillTreeButton();
    }
    public function redraw():void{
        tryRemoveChild(this.equippedGrid);
        tryRemoveChild(this.equippedGridBG);
        tryRemoveChild(this.interactPanel);
        tryRemoveChild(this.inventory);
        tryRemoveChild(this.stats);
        tryRemoveChild(this.backpack);
    }
    private function addButtons():void{
        for(var i:int = 1; i <=5;i++){
            var button:IconButton = new IconButtonFactory().create(new ImageFactory().getImageFromSet("lofiInterfaceBig", 0x17+i), "", "Tab", "");
            button.x = (i*30);
            button.y=300;
            button.addEventListener(MouseEvent.CLICK, TabSwitch(i));
            this.tabButtons[i-1]=button;
            addChild(button);

        }

    }
    private function updateButtons():void{
        for(var i:int =1;i <=5;i++){
            var button:IconButton = this.tabButtons[i-1];
            if(tab1==i || tab2==i) button.drawBackground(0xff0000);
            else button.removeBackground();
        }
    }
    private function TabSwitch(_arg_1:int):Function{
        var temp:int = _arg_1;
        return function(_arg_1:MouseEvent):void{
            changeTab(temp);
        }
    }
    private function changeTab(_arg_1:int):void{
        if(tab1==_arg_1) {
            tab1 = 0;
            tab1 = tab2;
            tab2 =0;
        }
        else if(tab2==_arg_1){
            tab2=0;
        }
        else if(tab1==0){
            tab1=_arg_1;
        }
        else if(tab2==0){
            tab2=_arg_1;
        }
        else{
            return;
        }
        toredraw = true;
    }

    public function tryRemoveChild(_arg_1:Sprite):void{
        try{
            removeChild(_arg_1);
        }
        catch(e:Error){}

    }
    private function addAssets():void {
        addChild(this.background);
        addChild(this.miniMap);
        //addChild(this.tabStrip);
        addChild(this.characterDetails);
        addChild(this.statMeters);
        addChild(this.skillTreeBtn);
    }
    private function createSkillTreeButton():void{

        this.skillTreeBtn = new IconButtonFactory().create(new ImageFactory().getImageFromSet("LunarSkillTreeIcon", 0), "", "Skill Tree", "");
        this.skillTreeBtn.x = SKILL_TREE_BTN_POSITION.x;
        this.skillTreeBtn.y = SKILL_TREE_BTN_POSITION.y;
        this.skillTreeBtn.addEventListener(MouseEvent.CLICK, function(_arg_1:MouseEvent):void{
            StaticInjectorContext.getInjector().getInstance(OpenDialogSignal).dispatch(new FriendListView(player));
        });
    }
    private function positionAssets():void {
        this.background.x = this.BG_POSITION.x;
        this.background.y = this.BG_POSITION.y;
        this.miniMap.x = this.MAP_POSITION.x;
        this.miniMap.y = this.MAP_POSITION.y;
        //this.tabStrip.x = this.TAB_STRIP_POSITION.x;
        //this.tabStrip.y = this.TAB_STRIP_POSITION.y;
        this.characterDetails.x = this.CHARACTER_DETAIL_PANEL_POSITION.x;
        this.characterDetails.y = this.CHARACTER_DETAIL_PANEL_POSITION.y;
        this.statMeters.x = this.STAT_METERS_POSITION.x;
        this.statMeters.y = this.STAT_METERS_POSITION.y;
    }
    public function drawTab1(_arg_1:GameSprite):void{
        switch(tab1){
            case 1:
                this.createEquippedGridBackground(tab1pos);
                this.createEquippedGrid(true,tab1pos);
                break;
            case 2:
                this.createStatsTab(tab1pos);
                break;
            case 3:
                this.createInventory(tab1pos);
                break;
            case 4:
                this.createInteractPanel(_arg_1,tab1pos);
                break;
            case 5:
                this.createBackPackTab(tab1pos);
                break;
        }
    }
    public function drawTab2(_arg_1:GameSprite):void{
        var tempPoint:Point = new Point(tab2pos.x,tab1==1?tab2pos.y-80:tab1==2?tab2pos.y-75:tab2pos.y);
        switch(tab2){
            case 1:
                this.createEquippedGridBackground(tempPoint);
                this.createEquippedGrid(true,tempPoint);
                break;
            case 2:
                this.createStatsTab(tempPoint);
                break;
            case 3:
                this.createInventory(tempPoint);
                break;
            case 4:
                this.createInteractPanel(_arg_1, tempPoint);
                break;
            case 5:
                this.createBackPackTab(tempPoint);
                break;
        }
    }
    public function setPlayerDependentAssets(_arg_1:GameSprite):void {
        redraw();
        this.player = _arg_1.map.player_;
        drawTab1(_arg_1);
        drawTab2(_arg_1);


    }
    private function createBackPackTab(_arg_1:Point):void{
        this.backpack=new BackpackTabContent(this.player);
        this.backpack.x = _arg_1.x-10;
        this.backpack.y = _arg_1.y;
        addChild(this.backpack);
    }
    private function createStatsTab(_arg_1:Point):void{
        this.stats = new StatsTabContent(110);
        this.stats.x = _arg_1.x-10;
        this.stats.y=_arg_1.y-40;
        addChild(this.stats);
    }
    private function createInteractPanel(_arg_1:GameSprite,_arg_2:Point):void {
        this.interactPanel = new InteractPanel(_arg_1, this.player, 200, 100);
        this.interactPanel.x = _arg_2.x-10;
        this.interactPanel.y = _arg_2.y-10;
        addChild(this.interactPanel);
    }
    public function createEquippedGrid(_arg_1:Boolean,_arg_2:Point):void {
        this.equippedGrid = new EquippedGrid(this.player, this.player.slotTypes_, this.player,0,_arg_1);
        this.equippedGrid.x = _arg_2.x;
        this.equippedGrid.y = _arg_2.y;
        addChild(this.equippedGrid);
    }
    private function createEquippedGridBackground(_arg_1:Point):void {
        var _local_3:Vector.<IGraphicsData>;
        var _local_1:GraphicsSolidFill = new GraphicsSolidFill(0x676767, 1);
        var _local_2:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        _local_3 = new <IGraphicsData>[_local_1, _local_2, GraphicsUtil.END_FILL];
        GraphicsUtil.drawCutEdgeRect(0, 0, 178, 46, 6, [1, 1, 1, 1], _local_2);
        this.equippedGridBG = new Sprite();
        this.equippedGridBG.x = (_arg_1.x - 3);
        this.equippedGridBG.y = (_arg_1.y - 3);
        this.equippedGridBG.graphics.drawGraphicsData(_local_3);
        addChild(this.equippedGridBG);
    }
    private function createInventory(_arg_1:Point):void{
        this.inventory = new InventoryTabContent(this.player);
        this.inventory.x = _arg_1.x-10;
        this.inventory.y=_arg_1.y-10;
        addChild(this.inventory);
    }
    public function draw(_arg_1:GameSprite):void {
        if(toredraw) {
            updateButtons();
            setPlayerDependentAssets(_arg_1);
            toredraw= false;
        }
        //if(tab1==4|| tab2==4) interactPanel.draw();
        if(tab1==1 || tab2==1)equippedGrid.draw();
    }

    public function startTrade(_arg_1:AGameSprite, _arg_2:TradeStart):void {
        if (!this.tradePanel) {
            this.tradePanel = new TradePanel(_arg_1, _arg_2);
            this.tradePanel.y = 200;
            this.tradePanel.addEventListener(Event.CANCEL, this.onTradeCancel);
            addChild(this.tradePanel);
            this.setNonTradePanelAssetsVisible(false);
        }
    }

    private function setNonTradePanelAssetsVisible(_arg_1:Boolean):void {
        this.characterDetails.visible = _arg_1;
        this.statMeters.visible = _arg_1;
        //this.tabStrip.visible = _arg_1;
        this.equippedGrid.visible = _arg_1;
        this.equippedGridBG.visible = _arg_1;
        this.interactPanel.visible = _arg_1;
    }

    public function tradeDone():void {
        this.removeTradePanel();
    }

    public function tradeChanged(_arg_1:TradeChanged):void {
        if (this.tradePanel) {
            this.tradePanel.setYourOffer(_arg_1.offer_);
        }
    }

    public function tradeAccepted(_arg_1:TradeAccepted):void {
        if (this.tradePanel) {
            this.tradePanel.youAccepted(_arg_1.myOffer_, _arg_1.yourOffer_);
        }
    }

    private function onTradeCancel(_arg_1:Event):void {
        this.removeTradePanel();
    }

    private function removeTradePanel():void {
        if (this.tradePanel) {
            SpriteUtil.safeRemoveChild(this, this.tradePanel);
            this.tradePanel.removeEventListener(Event.CANCEL, this.onTradeCancel);
            this.tradePanel = null;
            this.setNonTradePanelAssetsVisible(true);
        }
    }


}
}//package kabam.rotmg.ui.view
