require 'sinatra'
require 'json'
require 'ohai'

before do
  @system = Ohai::System.new
end

get "/" do
  # load system information
  @system.all_plugins

  sysinfo_hash = JSON.parse(@system.to_json)

  # flatten sysinfo_hash into @sysinfo
  @sysinfo = {}
  sysinfo_hash.each do |k, v|
    @sysinfo[k] = v
    if v.kind_of?(Hash) == false
      @sysinfo[k] = v
    else
      h = {}
      myflatten(h, '', v)
      @sysinfo[k] = h
    end
  end

  erb :index
end

# helper
# params:
#   target: a Hash
#   prefix: a string
#   value: Hash or not Hash
def myflatten(target, prefix, value)
  if value.kind_of?(Hash) == false
    target[prefix] = value
    return
  else
    value.each do |k, v|
      if (prefix.empty?)
        myflatten(target, prefix + k, v)
      else
        myflatten(target, prefix + '.' + k, v)
      end
    end
  end
end
