class FrontController < ApplicationController
  skip_before_filter :authenticate
end