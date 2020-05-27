// Decompiled by AS3 Sorcerer 1.40
// https://www.as3sorcerer.com/

//kabam****tmg.chat.control.ParseChatMessageCommand

package kabam.rotmg.chat.control{
    import kabam.rotmg.ui.model.HUDModel;
    import kabam.rotmg.game.signals.AddTextLineSignal;
    import kabam.rotmg.chat.model.ChatMessage;
    import com.company.assembleegameclient.parameters.Parameters;
    import kabam.rotmg.text.model.TextKey;

    public class ParseChatMessageCommand {

        [Inject]
        public var data:String;
        [Inject]
        public var hudModel:HUDModel;
        [Inject]
        public var addTextLine:AddTextLineSignal;

        public function execute():void {
            if(this.data.charAt(0) == "/") {
                var command:Array = this.data.substr(1, this.data.length).split(" ");
                switch (command[0]) {
                    case "help":
                        this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, TextKey.HELP_COMMAND));
                        return;
                    case "mscale":
                        if(command.length > 1) {
                            var mscale:Number = Number(command[1]);
                            if(mscale)
                                Parameters.data_.mscale = mscale;
                            Parameters.save();
                        }
                        this.addTextLine.dispatch(ChatMessage.make(Parameters.HELP_CHAT_NAME, "Map Scale: " + Parameters.data_.mscale));
                        return;

                }
            }
            this.hudModel.gameSprite.gsc_.playerText(this.data);
        }

    }
}