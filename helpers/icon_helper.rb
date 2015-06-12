module IconHelper
  def icon(name)
    case name
    when :leaf; return '&#xe800;'
    when :search; return '&#xe801;'
    when :volume_up; return '&#xe802;'
    when :menu; return '&#xe803;'
    when :facebook; return '&#xe804;'
    when :twitter; return '&#xe805;'
    when :tumblr; return '&#xe806;'
    when :mail_alt; return '&#xe807;'
    when :export_alt; return '&#xe808;'
    when :globe; return '&#xe809;'
    end
  end
end