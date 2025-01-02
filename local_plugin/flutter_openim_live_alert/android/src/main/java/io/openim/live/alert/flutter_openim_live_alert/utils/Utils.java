package io.openim.live.alert.flutter_openim_live_alert.utils;

import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

import java.util.List;

public class Utils {

    public static boolean isInstalled(Context context, String packageName) {
        try {
            final PackageManager packageManager = context.getPackageManager();
            // 获取所有已安装程序的包信息
            List<PackageInfo> infoList = packageManager.getInstalledPackages(0);
            for (int i = 0; i < infoList.size(); i++) {
                if (infoList.get(i).packageName.equalsIgnoreCase(packageName))
                    return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    public static boolean isRunningForeground(Context context) {
        ActivityManager activityManager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        if (null != activityManager) {
            List<ActivityManager.RunningAppProcessInfo> appProcessInfos = activityManager.getRunningAppProcesses();
            // 枚举进程
            for (ActivityManager.RunningAppProcessInfo appProcessInfo : appProcessInfos) {
                if (appProcessInfo.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND) {
                    if (appProcessInfo.processName.equals(context.getApplicationInfo().processName)) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    public static void moveTaskToFront(Context context, String packageName, String activityName) {
        //如果APP是在后台运行
        if (!isRunningForeground(context)) {
            //获取ActivityManager
            ActivityManager activityManager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
            if (null != activityManager) {
                //获得当前运行的task
                List<ActivityManager.RunningTaskInfo> taskList = activityManager.getRunningTasks(Integer.MAX_VALUE);
                for (ActivityManager.RunningTaskInfo rti : taskList) {
                    //找到当前应用的task，并启动task的栈顶activity，达到程序切换到前台
                    if (rti.topActivity.getPackageName().equals(packageName)) {
                        activityManager.moveTaskToFront(rti.id, 0);
//                        return;
                    }
                }
            }
            //若没有找到运行的task，用户结束了task或被系统释放，则重新启动
            if (null != activityName) {
                startActivity(context, activityName);
            }

        }
    }

    public static void startActivity(Context context, String activityName) {
        try {
            Class<?> clazz = Class.forName(activityName);
            Intent intent = new Intent(context, clazz);
//            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_SINGLE_TOP);
            context.startActivity(intent);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
