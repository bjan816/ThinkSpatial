using System;
using Godot;

namespace ThinkSpatial.think_spatial.scripts.csharp.event_system.type
{
	public partial class Message : Node
	{
		private Action _listeners;

		public void AddListener(Action listener)
		{
			_listeners += listener;
		}

		public void RemoveListener(Action listener)
		{
			_listeners -= listener;
		}

		public void Send()
		{
			_listeners?.Invoke();
		}
	}

	public class Message<T>
	{
		private Action<T> _listeners;

		public void AddListener(Action<T> listener)
		{
			_listeners += listener;
		}

		public void RemoveListener(Action<T> callback)
		{
			_listeners -= callback;
		}

		public void Send(T message)
		{
			_listeners?.Invoke(message);
		}
	}
}