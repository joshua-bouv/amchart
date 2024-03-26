defmodule AmchartWeb.HomeLive do
  use AmchartWeb, :live_view

  def render(assigns) do
    ~H"""
    <div id="chartdiv" class="h-52 w-auto" phx-hook="Chart" />
    <.button phx-click="add_live_points">Add Data to chart</.button>
    """
  end

  def handle_params(_unsigned_params, _uri, socket) do
    start_date_unix = 1_706_998_000_000

    {:noreply,
     assign(socket, fake_date_start: start_date_unix)
     |> push_event("add_default_points", %{
       points: [
         %{
           date:
             DateTime.from_unix!(start_date_unix, :millisecond)
             |> DateTime.add(864_000)
             |> DateTime.to_unix(:millisecond),
           value: 8
         },
         %{
           date:
             DateTime.from_unix!(start_date_unix, :millisecond)
             |> DateTime.add(1_728_000)
             |> DateTime.to_unix(:millisecond),
           value: 10
         },
         %{
           date:
             DateTime.from_unix!(start_date_unix, :millisecond)
             |> DateTime.add(2_592_000)
             |> DateTime.to_unix(:millisecond),
           value: 12
         },
         %{
           date:
             DateTime.from_unix!(start_date_unix, :millisecond)
             |> DateTime.add(3_456_000)
             |> DateTime.to_unix(:millisecond),
           value: 14
         },
         %{
           date:
             DateTime.from_unix!(start_date_unix, :millisecond)
             |> DateTime.add(4_320_000)
             |> DateTime.to_unix(:millisecond),
           value: 11
         }
       ]
     })}
  end

  def handle_event("add_live_points", _unsigned_params, socket) do
    new_fake_date_start = socket.assigns.fake_date_start + 86_400_000

    {:noreply,
     assign(socket, fake_date_start: new_fake_date_start)
     |> push_event("add_live_points", %{
       points: %{
         date: new_fake_date_start,
         value: :rand.uniform(25)
       }
     })}
  end
end
