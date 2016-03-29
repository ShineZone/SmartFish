# AssetsManager

Assets manager based on `Bulkloader`.

## Installation

	_context = new Context()
	.install( AssetsExtension );
	
## Usage

#####In View:
> extend `BaseView`   
> or  
> implement `IResourceInjection`


#####AssetsService
- 需要XML配置文件支持

		<?xml version="1.0" encoding="UTF-8"?>
		<root>
			<xmls folder="../release/">
			</xmls>
			<windows folder="../release/windows/">
			</windows>
			<widget folder="../release/modules/">
				<item id="store" p="1">storeModule.swf</item>
				<item id="store" p="2">taskModule.swf</item>
			</widget>
		</root>
		
		
		
## TODO
- 不需要缓存的Assets，提供清除缓存的接口