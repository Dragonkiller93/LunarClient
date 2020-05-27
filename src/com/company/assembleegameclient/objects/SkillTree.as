package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.ui.panels.Panel;

import kabam.rotmg.game.view.NameChangerPanel;
import kabam.rotmg.game.view.SkillPanel;

public class SkillTree extends GameObject implements IInteractiveObject {

    public var rankRequired_:int = 0;

    public function SkillTree(_arg_1:XML) {
        super(_arg_1);
        isInteractive_ = true;
    }

    public function setRankRequired(_arg_1:int):void {
        this.rankRequired_ = _arg_1;
    }

    public function getPanel(_arg_1:GameSprite):Panel {
        return (new SkillPanel(_arg_1, this.rankRequired_));
    }
}
}
