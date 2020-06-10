
package kabam.rotmg.lunarmarket.utils {
import com.company.assembleegameclient.game.AGameSprite;
import com.company.assembleegameclient.ui.dialogs.Dialog;

import flash.events.Event;

public class DialogUtils
{
    /* Creates and adds an error dialog to the overlay */
    public static function makeSimpleDialog(gameSprite:AGameSprite, title:String, description:String) : void
    {
        var dialog:Dialog = new Dialog(description, title, "Close", null, true);
        dialog.addEventListener(Dialog.LEFT_BUTTON, onDialogClose);
        gameSprite.mui_.layers.overlay.addChild(dialog);
    }

    /* Creates and adds a confirm dialog to the overlay */
    public static function makeCallbackDialog(gameSprite:AGameSprite, title:String, description:String, textOne:String, textTwo:String,  callback:Function) : void
    {
        var dialog:Dialog = new Dialog(description, title, textOne, textTwo, true);
        dialog.addEventListener(Dialog.LEFT_BUTTON, callback); /* Should probably remove this as it could potentially cause a memory leak if used often */
        dialog.addEventListener(Dialog.LEFT_BUTTON, onDialogClose); /* Add this so we dont have to provide closing callback */
        dialog.addEventListener(Dialog.LEFT_BUTTON, onDialogClose);
        gameSprite.mui_.layers.overlay.addChild(dialog);
    }

    /* Removes the dialog made by the above two functions */
    private static function onDialogClose(event:Event) : void
    {
        var dialog:Dialog = event.currentTarget as Dialog;
        dialog.removeEventListener(Dialog.LEFT_BUTTON, onDialogClose);
        dialog.removeEventListener(Dialog.LEFT_BUTTON, onDialogClose);
        dialog.parent.removeChild(dialog);
    }
}
}