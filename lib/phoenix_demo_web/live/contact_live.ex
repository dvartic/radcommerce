defmodule PhoenixDemoWeb.ContactLive do
  use PhoenixDemoWeb, :live_view

  import Swoosh.Email

  alias PhoenixDemo.Mailer

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    form = to_form(%{"name" => "", "email" => "", "message" => ""})

    {:ok, socket |> assign(form: form)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-8 max-w-prose">
      <div class="flex flex-col gap-4">
        <h1 class="text-center lg:text-left font-heading text-6xl">
          {gettext("Contacto")}
        </h1>
        <p class="text-">
          {gettext(
            "No dudes en ponerte en contacto con nosotros si tienes alguna duda. Contestamos en menos de 24 horas."
          )}
        </p>
      </div>

      <%!-- Contact form --%>
      <.simple_form
        for={@form}
        id="contact_form"
        class="flex flex-col gap-4"
        phx-submit="contact_form"
        phx-change="validate"
      >
        <.input
          field={@form[:name]}
          type="text"
          placeholder={gettext("Nombre")}
          class="input input-bordered w-full"
          required
        />
        <.input
          field={@form[:email]}
          type="email"
          placeholder={gettext("Correo electrónico")}
          class="input input-bordered w-full"
          required
        />
        <.input
          field={@form[:message]}
          type="textarea"
          placeholder={gettext("Escribe tu mensaje aquí...")}
          class="textarea textarea-bordered"
          required
        />
        <:actions>
          <button
            id="3b989f58-f73a-4dec-b16b-9668f354a809"
            class="btn btn-primary"
            phx-hook="FormSubmitOnMousedown"
          >
            {gettext("Enviar")}
          </button>
        </:actions>
      </.simple_form>

      <p class="mt-4">
        {gettext("También puedes contactar con nosotros a través de correo electrónico:")}
        <a href="mailto:info@acgmicro.com" class="font-bold underline">info@acgmicro.com</a>
      </p>
    </div>
    """
  end

  @impl true
  def handle_event(
        "contact_form",
        %{"name" => name, "email" => email, "message" => message},
        socket
      ) do
    swoosh_email =
      new()
      |> to("info@acgmicro.com")
      |> from({"ACG Micro Backend - Contact Form", "noreply@acgmicro.com"})
      |> subject("Contact Form ACG Micro")
      |> text_body("""
      Name: #{name}
      Email: #{email}

      Message:
      #{message}
      """)

    case Mailer.deliver(swoosh_email) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(
           :info,
           gettext("Mensaje enviado correctamente. Nos pondremos en contacto contigo pronto.")
         )
         |> assign(form: to_form(%{"name" => "", "email" => "", "message" => ""}))}

      {:error, error} ->
        Logger.error("Error sending contact form email, details: #{inspect(error)}")

        {:noreply,
         socket
         |> put_flash(
           :error,
           gettext(
             "Error al enviar el mensaje. Intenta más tarde o contacta directamente via email."
           )
         )}
    end
  end

  def handle_event("validate", %{"name" => name, "email" => email, "message" => message}, socket) do
    {:noreply,
     socket |> assign(form: to_form(%{"name" => name, "email" => email, "message" => message}))}
  end
end
