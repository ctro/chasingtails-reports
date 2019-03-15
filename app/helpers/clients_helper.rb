# Client Helper Module
module ClientsHelper
  def dog_links(client)
    client.dogs.map do |d|
      link_to d.name, client_dog_path(client, d)
    end.join(', ')
  end
end
