package kabam.rotmg.game.view.components {
import flash.display.Sprite;

import kabam.rotmg.ui.model.TabStripModel;

public class StatsTabContent extends Sprite {

    private var stats:StatsView;

    public function StatsTabContent(_arg_1:uint) {
        this.stats = new StatsView();
        super();
        this.init();
        this.positionChildren(_arg_1);
        this.addChildren();
        this.drawBackground();
    }
    private function drawBackground():void{
        graphics.lineStyle(0,0);
        graphics.beginFill(0x333333,1);
        graphics.drawRoundRect(-10,-10,width,height+20,20,20);
    }
    private function addChildren():void {
        addChild(this.stats);
    }

    private function positionChildren(_arg_1:uint):void {
        this.stats.y = (((_arg_1 - TabConstants.TAB_TOP_OFFSET) / 2) - (this.stats.height / 2));
    }

    private function init():void {
        this.stats.name = TabStripModel.STATS;
    }


}
}//package kabam.rotmg.game.view.components
