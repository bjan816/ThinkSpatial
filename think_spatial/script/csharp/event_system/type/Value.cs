using System;
using Godot;

namespace ThinkSpatial.think_spatial.script.csharp.event_system.type
{
	public partial class Value<T> : Node
	{
		private Action _changeListeners;
		private T _currentValue;
		private T _previousValue;

		public Value(T initialValue)
		{
			_currentValue = initialValue;
			_previousValue = _currentValue;
		}

		public bool Is(T value)
		{
			return _currentValue != null && _currentValue.Equals(value);
		}

		public void AddChangeListener(Action callback)
		{
			_changeListeners += callback;
		}

		public void RemoveChangeListener(Action callback)
		{
			_changeListeners -= callback;
		}

		public T Get()
		{
			return _currentValue;
		}

		public T GetLastValue()
		{
			return _previousValue;
		}

		public void Set(T value)
		{
			_previousValue = _currentValue;
			_currentValue = value;

			if (_changeListeners != null && (_previousValue == null || !_previousValue.Equals(_currentValue)))
			{
				_changeListeners();
			}
		}
	}
}