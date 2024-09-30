defmodule PhoenixDemoWeb.Products.Product.ProductView do
  use Phoenix.Component
  import PhoenixDemoWeb.CoreComponents

  # Product Schema
  alias PhoenixDemo.Schemas.Product

  alias PhoenixDemoWeb.Admin.ProductsLive

  attr :product, Product, required: true
  attr :form, Phoenix.HTML.Form, required: true

  def product_view(assigns) do
    # Image Src
    assigns =
      assign(
        assigns,
        :img_src_list,
        assigns.product.images
        |> Enum.map(fn rel_src -> ProductsLive.file_url(rel_src) end)
        |> then(fn
          list when list == [] -> [ProductsLive.file_url("image-off.svg")]
          list -> list
        end)
      )

    # Properties Json Parsing
    properties_parsed =
      if assigns.product.properties == nil do
        nil
      else
        with {:ok, value} <- Jason.decode(assigns.product.properties) do
          value
        else
          {:error, _reason} -> nil
        end
      end

    assigns =
      assign(
        assigns,
        :properties_parsed,
        properties_parsed
      )

    # Product description markdown processing
    markdown_desc =
      MDEx.to_html(assigns.product.description || "")
      |> Phoenix.HTML.raw()

    assigns = assign(assigns, :markdown_desc, markdown_desc)

    ~H"""
    <.form
      for={@form}
      phx-change="validate"
      phx-submit="save"
      autocomplete="off"
      class="grid grid-cols-1 lg:grid-cols-2 gap-10 lg:gap-14 border rounded-lg shadow p-4 md:p-12 bg-white dark:bg-black"
    >
      <%!-- PRODUCT IMAGES --%>
      <div
        class="flex flex-col gap-6 lg:gap-12 items-center"
        x-data={"{selectedImg: 0, imagesList: #{Jason.encode!(@img_src_list)}}"}
      >
        <div class="flex flex-col gap-2 items-center">
          <img class="h-[300px] sm:h-[500px] object-contain" x-bind:src="imagesList[selectedImg]" />

          <%!-- Move left right buttons --%>
          <div class="flex flex-row gap-2">
            <button
              class="btn btn-circle"
              x-on:click="if (selectedImg >= 0) selectedImg--"
              x-bind:disabled="selectedImg <= 0"
              type="button"
            >
              <.icon name="hero-arrow-left" class="h-6 w-6" />
            </button>
            <button
              class="btn btn-circle"
              x-on:click="if (selectedImg < imagesList.length - 1) selectedImg++"
              x-bind:disabled="selectedImg === (imagesList.length - 1)"
              type="button"
            >
              <.icon class="h-6 w-6" name="hero-arrow-right" />
            </button>
          </div>
        </div>

        <div class="max-w-full flex flex-row flex-wrap justify-center gap-4 px-2 py-6">
          <%= for {img_src, index} <- Enum.with_index(@img_src_list) do %>
            <div
              class="flex items-center justify-center ring-1 rounded-md h-20 sm:h-28 p-2 aspect-square cursor-pointer shadow hover:shadow-lg"
              x-on:click={"selectedImg = #{index}"}
              x-bind:class={"{'ring-accent': selectedImg === #{index}, 'ring-neutral-content': selectedImg !== #{index}}"}
            >
              <img class="h-full object-contain" src={img_src} />
            </div>
          <% end %>
        </div>
      </div>

      <%!-- PRODUCT DESC --%>
      <div class="flex flex-col gap-8">
        <%!-- TITLE AND PRICE --%>
        <div class="flex flex-col gap-6 pb-6 border-b">
          <h1 class="font-bold text-4xl"><%= @product.name %></h1>
          <div class="font-mono font-medium text-xl"><%= @product.price %></div>
        </div>
        <%!-- OPTIONS --%>
        <div class="flex flex-col gap-6">
          <%= if @properties_parsed != nil do %>
            <%= for {key, valueList} <- @properties_parsed do %>
              <div class="flex flex-col gap-2">
                <div class="font-bold text-lg"><%= key %><sup class="text-error"> *</sup></div>
                <div class="flex flex-row gap-3 flex-wrap">
                  <%= for value <- valueList do %>
                    <fieldset>
                      <label class="btn btn-outline btn-sm has-[:checked]:btn-active">
                        <span><%= value %></span>
                        <div class="hidden">
                          <.input
                            type="radio"
                            id={"#{key}:#{value}"}
                            name={key}
                            value={value}
                            phx-update="ignore"
                          />
                        </div>
                      </label>
                    </fieldset>
                  <% end %>
                </div>
              </div>
            <% end %>
          <% end %>
        </div>

        <%!-- TEXT --%>
        <div class="markdown-render prose">
          <%= @markdown_desc %>
        </div>

        <div class="flex flex-col gap-2">
          <%!-- GLOBAL ERRORS --%>
          <div class="h-[40px]">
            <%= if @form.errors[:global] != nil do %>
              <p class="text-error text-sm"><%= elem(@form.errors[:global], 0) %></p>
            <% end %>
          </div>
          <%!-- ACTION --%>
          <button class="btn btn-block btn-primary btn-lg phx-submit-loading:opacity-75">
            <.icon name="hero-plus" class="h-6 w-6" /> Añadir a carrito
          </button>
        </div>
      </div>
    </.form>
    """
  end
end
