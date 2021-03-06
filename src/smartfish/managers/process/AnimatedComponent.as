package smartfish.managers.process
{    
    import flash.events.EventDispatcher;
    
    public class AnimatedComponent extends EventDispatcher implements IAnimatedObject
    {
        /**
         * The update priority for this component. Higher numbered priorities have
         * OnFrame called before lower priorities.
         */
        public var updatePriority:Number = 0.0;
        
        private var _registerForUpdates:Boolean = true;
        private var _isRegisteredForUpdates:Boolean = false;
		private var initialRegisterForUpdates:Boolean = true;
        
        /**
         * Set to register/unregister for frame updates.
         */
        public function set registerForUpdates(value:Boolean):void
        {
            _registerForUpdates = value;
            
            if(_registerForUpdates && !_isRegisteredForUpdates)
            {
                // Need to register.
                _isRegisteredForUpdates = true;
                ProcessManager.getInstance().addAnimatedObject(this, updatePriority);
            }
            else if(!_registerForUpdates && _isRegisteredForUpdates)
            {
                _isRegisteredForUpdates = false;
				ProcessManager.getInstance().removeAnimatedObject(this);
            }
        }
        
        /**
         * @private
         */
        public function get registerForUpdates():Boolean
        {
            return _registerForUpdates;
        }
        
        /**
         * @inheritDoc
         */
        public function onFrame(deltaTime:Number):void
        {
        }
        
        protected function onAdd():void
        {
			// keep initial _registerFoUpdates value so we can reset this if the component to its 
			// initial state after it is removed and before it is added again to an entity.
			initialRegisterForUpdates = _registerForUpdates;
			// registerForTicks could be set to a specific value(false) using XML
			// so by setting it so its own value we will actually register if we weren't already.
            registerForUpdates = registerForUpdates;
        }
        
		protected function onRemove():void
        {
            // Make sure we are unregistered.
            registerForUpdates = false;
			// reset _registerForUpdates value so we got a healthy initial condition when we  
			// add this component to an entity again.
			_registerForUpdates = initialRegisterForUpdates; 
        }
    }
}