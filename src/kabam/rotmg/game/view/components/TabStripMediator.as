﻿package kabam.rotmg.game.view.components {
import com.company.assembleegameclient.objects.ImageFactory;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.icons.IconButtonFactory;

import flash.events.MouseEvent;

import kabam.rotmg.assets.services.IconFactory;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.friends.view.FriendListView;
import kabam.rotmg.pets.controller.NotifyActivePetUpdated;
import kabam.rotmg.pets.data.PetsModel;
import kabam.rotmg.pets.view.components.PetsTabContentView;
import kabam.rotmg.ui.model.HUDModel;
import kabam.rotmg.ui.model.TabStripModel;
import kabam.rotmg.ui.signals.UpdateBackpackTabSignal;
import kabam.rotmg.ui.signals.UpdateHUDSignal;
import kabam.rotmg.ui.view.StatsDockedSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

public class TabStripMediator extends Mediator {

    [Inject]
    public var view:TabStripView;
    [Inject]
    public var hudModel:HUDModel;
    [Inject]
    public var tabStripModel:TabStripModel;
    [Inject]
    public var updateHUD:UpdateHUDSignal;
    [Inject]
    public var updateBackpack:UpdateBackpackTabSignal;
    [Inject]
    public var notifyActivePetUpdated:NotifyActivePetUpdated;
    [Inject]
    public var iconFactory:IconFactory;
    [Inject]
    public var imageFactory:ImageFactory;
    [Inject]
    public var iconButtonFactory:IconButtonFactory;
    [Inject]
    public var statsUndocked:StatsUndockedSignal;
    [Inject]
    public var statsDocked:StatsDockedSignal;
    [Inject]
    public var statsTabHotKeyInput:StatsTabHotKeyInputSignal;
    [Inject]
    public var petModel:PetsModel;
    [Inject]
    public var openDialog:OpenDialogSignal;
    private var doShowStats:Boolean = true;


    override public function initialize():void {
        this.view.imageFactory = this.imageFactory;
        this.view.iconButtonFactory = this.iconButtonFactory;
        this.view.tabSelected.add(this.onTabSelected);
        this.updateHUD.addOnce(this.addTabs);
        this.statsUndocked.add(this.onStatsUndocked);
        this.statsDocked.add(this.onStatsDocked);
        this.statsTabHotKeyInput.add(this.onTabHotkey);
        this.notifyActivePetUpdated.add(this.onNotifyActivePetUpdated);
        //this.view.initSkillTree(this.imageFactory, this.iconButtonFactory, this.onSkillBtnClicked);
    }

    private function onStatsUndocked(_arg_1:StatsView):void {
//        this.doShowStats = false;
//        this.clearTabs();
//        this.addTabs(this.hudModel.gameSprite.map.player_);
    }

    private function onStatsDocked():void {
//        this.doShowStats = true;
//        this.clearTabs();
//        this.addTabs(this.hudModel.gameSprite.map.player_);
//        this.view.setSelectedTab(1);
    }

    private function onTabHotkey():void {
        var _local_1:int = (this.view.currentTabIndex + 1);
        _local_1 = (_local_1 % this.view.tabs.length);
        this.view.setSelectedTab(_local_1);
    }

    override public function destroy():void {
        this.view.tabSelected.remove(this.onTabSelected);
        this.updateBackpack.remove(this.onUpdateBackPack);
    }

    private function onSkillBtnClicked(_arg_1:MouseEvent):void {
        this.openDialog.dispatch(new FriendListView(this.hudModel.gameSprite.map.player_));
    }

    private function addTabs(_arg_1:Player):void {
        if (!_arg_1) {
            return;
        }
        //this.view.addTab(this.iconFactory.makeIconBitmap(TabConstants.INVENTORY_ICON_ID), new InventoryTabContent(_arg_1));
        if (this.doShowStats) {
            this.view.addTab(this.iconFactory.makeIconBitmap(TabConstants.STATS_ICON_ID), new StatsTabContent(this.view.HEIGHT));
        }
        if (_arg_1.hasBackpack_) {
            this.view.addTab(this.iconFactory.makeIconBitmap(TabConstants.BACKPACK_ICON_ID), new BackpackTabContent(_arg_1));
        }
        else {
            this.updateBackpack.add(this.onUpdateBackPack);
        }
        if (this.petModel.getActivePet()) {
            this.view.addTab(this.iconFactory.makeIconBitmap(TabConstants.PETS_ICON_ID), new PetsTabContentView());
        }
    }

    private function clearTabs():void {
        this.view.clearTabs();
    }

    private function onTabSelected(_arg_1:String):void {
        this.tabStripModel.currentSelection = _arg_1;
    }

    private function onUpdateBackPack(_arg_1:Boolean):void {
        var _local_2:Player;
        if (_arg_1) {
            _local_2 = this.hudModel.gameSprite.map.player_;
            this.view.addTab(this.iconFactory.makeIconBitmap(TabConstants.BACKPACK_ICON_ID), new BackpackTabContent(_local_2));
            this.updateBackpack.remove(this.onUpdateBackPack);
        }
    }

    private function onNotifyActivePetUpdated():void {
        this.clearTabs();
        this.addTabs(this.hudModel.gameSprite.map.player_);
    }


}
}//package kabam.rotmg.game.view.components
