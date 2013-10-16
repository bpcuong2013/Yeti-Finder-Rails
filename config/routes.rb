YetiFinderRails::Application.routes.draw do
  root :to                                      => 'yeti_finding#index'
  get '/'                                       => 'yeti_finding#index'
end
