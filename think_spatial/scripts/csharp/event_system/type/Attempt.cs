using System;
using Godot;

namespace ThinkSpatial.think_spatial.script.csharp.event_system.type
{
	public partial class Attempt : Node
	{
		public delegate bool TryerDelegate();

		private TryerDelegate _tryer;
		private Action _listeners;

		public void SetTryer(TryerDelegate tryer)
		{
			_tryer = tryer;
		}

		public void AddListener(Action listener)
		{
			_listeners += listener;
		}

		public void RemoveListener(Action listener)
		{
			_listeners -= listener;
		}

		public bool Try()
		{
			bool successful = _tryer == null || _tryer();

			if (successful)
			{
				_listeners?.Invoke();
				return true;
			}

			return false;
		}
	}

	public class Attempt<T>
	{
		public delegate bool TryerDelegate(T arg);

		TryerDelegate _tryer;
		Action<T> _listeners;

		public void SetTryer(TryerDelegate tryer)
		{
			_tryer = tryer;
		}

		public void AddListener(Action<T> listener)
		{
			_listeners += listener;
		}

		public void RemoveListener(Action<T> listener)
		{
			_listeners -= listener;
		}

		public bool Try(T argument)
		{
			bool successful = _tryer != null && _tryer(argument);

			if (successful)
			{
				_listeners?.Invoke(argument);

				return true;
			}

			return false;
		}
	}
}
