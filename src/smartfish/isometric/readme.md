# Isometric engine

> Version 1.0

### QuickStart
	
	
	var _scene:IIsoScene = new IsoScene();
	
	//视图是最外层的一个东西，可以控制整体的一个操作，如地图的拖拽等
	var _view:IsoView = new IsoView( 760, 650 );
	_view.addScene( _scene );
	addChild( _view );
	
	//添加一个显示精灵
	var _sprite:IIsoSprite = new IsoSprite();
	_scene.addChild(_sprite);
	//可以设置材质
	_sprite.sprites = [bitmap, shape...];
	
	//scene 渲染   当场景内发生变化时，可以调用渲染显示
	_scene.renderer();


### 基础功能

- 坐标转换
> Isometric to screen   
> Screen to isometric

		//坐标转换算法
		IsoMath.isoToScreen(pos:IsoPoint):Point
		IsoMath.screenToIso(point:Point):IsoPoint
		
		//通过全局坐标 与 Isometric world坐标 转换
		var _isoView:IsoView = new IsoView();
		_isoView.localToIso( new Point(isoX, isoY) ):IsoPoint
		_isoView.isoToLocal( isoPt:IsoPoint ):Point
		


- 深度排序
> 基于Scene的排序

		//把场景实例传入，该类即可针对场景内物体排序
		//scene可以实现2个方法， 其中sortChildren是只针对屏幕范围内的物体，displayListChildren是所有物体
		//在排序方法内可以旋转获取sortChildren来优化
		DefaultSceneSort::function renderScene(scene:IIsoScene):void;


- 场景管理
> 多场景支持

		//主场景
		var _mainScene:IIsoScene = new IsoScene();
		
		var _houseScene:IIsoScene = new IsoScene();
		var _gardenScene:IIsoScene = new IsoScene();
		var _kursaalScene:IIsoScene = new IsoScene();
		
		//马路元素
		var _roadSprite:IIsoSprite = new IsoSprite();
	
		//添加到主场景
		_mainScene.addChild(_houseScene);
		_mainScene.addChild(_gardenScene);
		_mainScene.addChild(_kursaalScene);
		_mainScene.addChild(_roadSprite);


- 地图操作
> 移动

		_isoView.panTo( 20, 50 );
> 拖拽   

		_isoView.canMapDrag = true;
> 缩放   

		_isoView.zoom( .5 );


- IsoSprite   
> 添加任意DisplayObject材质 
 
		_isoSprite.sprites = [Sprite, MovieClip, Bitmap, BitmapData, Shape];

- 元素操作
	+ 移动  
	
			_isoSprite.moveTo( x : Number, y : Number )
			_isoSprite.moveIndexTo( x : int, y : int )



### EXTENSIONS

> 考虑到IsoSprite应该会含有大量的扩展功能，这块将基于插件形式来开发。   
> 扩展的功能只需实现IIsoSpriteExtension即可。


+ PathfindingExtension

		interface IPathfinding
		{
			/**
		 	* 通过寻路去向目标点 
		 	* @param x
		 	* @param y
		 	*/		
			function pathFindingTo( x:Number = 0, y:Number = 0 ):Boolean;
		
			/**
		 	* 改变方向 
		 	* @return 
		 	*/		
			function get changeDirectionMsg():Signal;
		
			/**
		 	* 移动结束 
		 	* @return 
		 	*/		
			function get pathToOverMsg():Signal;
		
			/**
		 	* 进入场景可见区域 
		 	* @return 
		 	*/		
			function get inSceneViewMsg():Signal;
		
			/**
		 	* 离开场景可见区域 
		 	* @return 
		 	*/		
			function get outSceneViewMsg():Signal;
		}
		
+ DragExtension
		
		interface IDragger
		{
			function drag():void;
			function put():void;
		}


---
另外还有一个小工具IsoCreator，他可以创建一些Isometric视角的图形，方便开发阶段调试等等。






### TODO

- 





### Q&A

- 物体旋转   
- IsoView外面的逻辑停止    
- 鼠标事件操作   
- 摆放层级
- 同格子物体权重
- 寻路优化 分区域  cache区域间

