import android.app.Application;

import com.yandex.mapkit.MapKitFactory;

public class MainApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        MapKitFactory.setApiKey("485147d5-5a66-4723-bcbe-096b8450106a");
    }
}