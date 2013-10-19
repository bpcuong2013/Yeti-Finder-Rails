YetiFinderRails::Application.routes.draw do
  get "yeti/index"

  root :to                      => 'yeti#index'
  get '/'                       => 'yeti#index'
  get '/yeti/listCities'        => 'yeti#listCities'
  get '/yeti/listNamedYetis'    => 'yeti#listNamedYetis'
  post '/yeti/createNamedYeti'  => 'yeti#createNamedYeti'
  get '/yeti/deleteNamedYeti'  => 'yeti#deleteNamedYeti'
  
  post '/yeti_finding/detectDevice'     => 'yeti_finding#detectDevice'
  post '/yeti_finding/joinSystem'       => 'yeti_finding#joinSystem'
  post '/yeti_finding/findYetis'        => 'yeti_finding#findYetis'
  post '/yeti_finding/saveYetiFound'    => 'yeti_finding#saveYetiFound'
  post '/yeti_finding/getScoreboard'    => 'yeti_finding#getScoreboard'
end
