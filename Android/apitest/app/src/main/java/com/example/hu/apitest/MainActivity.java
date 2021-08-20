package com.example.hu.apitest;

import java.net.URISyntaxException;

import com.tencent.wework.api.IWWAPI;
import com.tencent.wework.api.IWWAPIEventHandler;
import com.tencent.wework.api.WWAPIFactory;
import com.tencent.wework.api.model.BaseMessage;
import com.tencent.wework.api.model.WWAuthMessage;
import com.tencent.wework.api.model.WWMediaConversation;
import com.tencent.wework.api.model.WWMediaFile;
import com.tencent.wework.api.model.WWMediaImage;
import com.tencent.wework.api.model.WWMediaLink;
import com.tencent.wework.api.model.WWMediaMergedConvs;
import com.tencent.wework.api.model.WWMediaText;
import com.tencent.wework.api.model.WWMediaVideo;

import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

public class MainActivity extends Activity {

	IWWAPI iwwapi;
	int stringId;
    private static final String APPID = "WW5ce2489834f4ac82";
    private static final String AGENTID = "1000016";
    private static final String SCHEMA = "WW5ce2489834f4ac82";
	WWMediaMergedConvs wmc = new WWMediaMergedConvs();

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		stringId = getApplicationInfo().labelRes;
		iwwapi = WWAPIFactory.createWWAPI(this);
		iwwapi.registerApp(SCHEMA);
		findViewById(R.id.btutl).setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {

				// 发送链接
				WWMediaLink link = new WWMediaLink();
				link.thumbUrl = ((EditText) findViewById(R.id.et2)).getText().toString();
				link.webpageUrl = ((EditText) findViewById(R.id.et1)).getText().toString();
				link.title = ((EditText) findViewById(R.id.et3)).getText().toString();
				link.description = ((EditText) findViewById(R.id.et4)).getText().toString();
				link.appPkg = getPackageName();
				link.appName = getString(stringId);
                link.appId = APPID;
                link.agentId = AGENTID;
				iwwapi.sendMessage(link);

				WWMediaConversation wc = new WWMediaConversation();
				wc.name = ((EditText) findViewById(R.id.et4)).getText().toString();
				wc.date = System.currentTimeMillis();
				wc.message = link;
				wc.avatarPath = "http://static.cnbetacdn.com/topics/5d57f064cd38d29.png";
				wmc.addItem(wc);
			}
		});
		findViewById(R.id.btut2).setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				// 发送文本
				WWMediaText txt = new WWMediaText(
						((EditText) findViewById(R.id.et3)).getText().toString());
				txt.appPkg = getPackageName();
				txt.appName = getString(stringId);
                txt.appId = APPID;
                txt.agentId = AGENTID;
				iwwapi.sendMessage(txt);

				WWMediaConversation wc = new WWMediaConversation();
				wc.name = ((EditText) findViewById(R.id.et4)).getText().toString();
				wc.date = System.currentTimeMillis();
				wc.message = txt;
				wc.avatarPath = "https://www.baidu.com/img/bd_logo1.png";
				wmc.addItem(wc);
			}
		});
		findViewById(R.id.btut3).setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
				intent.setType("*/*");
				intent.addCategory(Intent.CATEGORY_OPENABLE);

				try {
					startActivityForResult(Intent.createChooser(intent, "Select a File to Upload"),
							0);
				} catch (android.content.ActivityNotFoundException ex) {
				}

			}
		});
		findViewById(R.id.btut4).setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				Intent i = new Intent(Intent.ACTION_PICK,
						android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
				startActivityForResult(i, 1);
			}
		});

        findViewById(R.id.btut7).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent i = new Intent(Intent.ACTION_PICK,
                        android.provider.MediaStore.Video.Media.EXTERNAL_CONTENT_URI);
                startActivityForResult(i, 2);
            }
        });

		findViewById(R.id.btut5).setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				wmc.appPkg = getPackageName();
				wmc.appName = getString(stringId);
                wmc.appId = APPID;
                wmc.agentId = AGENTID;
				wmc.title = ((EditText) findViewById(R.id.et3)).getText().toString();
				iwwapi.sendMessage(wmc);
				wmc = new WWMediaMergedConvs();
			}
		});

		findViewById(R.id.btut6).setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				final WWAuthMessage.Req req = new WWAuthMessage.Req();
				req.sch = SCHEMA;
				req.appId = APPID;
				req.agentId = AGENTID;
				req.state = "dd";
				iwwapi.sendMessage(req, new IWWAPIEventHandler() {
					@Override
					public void handleResp(BaseMessage resp) {
						if (resp instanceof WWAuthMessage.Resp) {
							WWAuthMessage.Resp rsp = (WWAuthMessage.Resp) resp;
                            if (rsp.errCode == WWAuthMessage.ERR_CANCEL) {
								Toast.makeText(MainActivity.this, "登陆取消", Toast.LENGTH_SHORT).show();
							}else if (rsp.errCode == WWAuthMessage.ERR_FAIL) {
								Toast.makeText(MainActivity.this, "登陆失败", Toast.LENGTH_SHORT).show();
							} else if (rsp.errCode == WWAuthMessage.ERR_OK) {
								Toast.makeText(MainActivity.this, "登陆成功：" + rsp.code,
										Toast.LENGTH_SHORT).show();
							}
						}
					}
				});
			}
		});
	}

	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		if (resultCode != RESULT_OK) {
			return;
		}
		if (requestCode == 0) {
			Uri uri = data.getData();
			try {
				String path = getPath(uri);
				// 发送文件
				WWMediaFile file = new WWMediaFile();
				file.fileName = "test";
				file.filePath = path;
				file.appPkg = getPackageName();
				file.appName = getString(stringId);
                file.appId = APPID;
                file.agentId = AGENTID;
				iwwapi.sendMessage(file);

				WWMediaConversation wc = new WWMediaConversation();
				wc.name = ((EditText) findViewById(R.id.et4)).getText().toString();
				wc.date = System.currentTimeMillis();
				wc.message = file;
				wc.avatarPath = "https://www.baidu.com/img/bd_logo1.png";
				wmc.addItem(wc);
			} catch (URISyntaxException e) {
				e.printStackTrace();
			}
		}
        if (requestCode == 2) {
            Uri uri = data.getData();
            try {
                String path = getPath(uri);
                //发送视频
                WWMediaVideo video = new WWMediaVideo();
                video.fileName = "test";
                video.filePath = path;
                video.appPkg = getPackageName();
                video.appName = getString(stringId);
                video.appId = APPID;
                video.agentId = AGENTID;
                iwwapi.sendMessage(video);

                WWMediaConversation wc = new WWMediaConversation();
                wc.name = ((EditText) findViewById(R.id.et4)).getText().toString();
                wc.date = System.currentTimeMillis();
                wc.message = video;
                wc.avatarPath = "https://www.baidu.com/img/bd_logo1.png";
                wmc.addItem(wc);
            } catch (URISyntaxException e) {
                e.printStackTrace();
            }
        }
		if (requestCode == 1) {
			Uri uri = data.getData();
			try {
				String path = getPath(uri);
				// 发图片
				WWMediaImage img = new WWMediaImage();
				img.fileName = "test";
				img.filePath = path;
				img.appPkg = getPackageName();
				img.appName = getString(stringId);
                img.appId = APPID;
                img.agentId = AGENTID;
				iwwapi.sendMessage(img);
				WWMediaConversation wc = new WWMediaConversation();
				wc.name = ((EditText) findViewById(R.id.et4)).getText().toString();
				wc.date = System.currentTimeMillis();
				wc.message = img;
				wc.avatarPath = "http://static.cnbetacdn.com/thumb/mini/article/2016/0810/d53ceebb40941a5_100x100.jpg";
				wmc.addItem(wc);
			} catch (URISyntaxException e) {
				e.printStackTrace();
			}
		}
	}

	public String getPath(Uri uri) throws URISyntaxException {
		if ("content".equalsIgnoreCase(uri.getScheme())) {
			String[] projection = { MediaStore.Images.Media.DATA };
			Cursor cursor = null;

			try {
				cursor = getContentResolver().query(uri, projection, null, null, null);
				if (cursor.moveToFirst()) {
					return cursor.getString(0);
				}
			} catch (Exception e) {
				// Eat it
			}
			if (cursor != null) {
				cursor.close();
			}
		} else if ("file".equalsIgnoreCase(uri.getScheme())) {
			return uri.getPath();
		}

		return null;
	}
}
