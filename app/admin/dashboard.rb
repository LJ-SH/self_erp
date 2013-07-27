ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    #default dashboard code ========================
    #div :class => "blank_slate_container", :id => "dashboard_default_message" do
    #  span :class => "blank_slate" do
    #    span I18n.t("active_admin.dashboard_welcome.welcome")
    #    small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #  end
    #end

    columns do
      column do
        panel t 'label.part_number_outstanding_inventory' do
          table_for Inventory.part_number.order('quantity_of_surplus desc').limit(10) do
            column(I18n.t('activerecord.attributes.part_number.code'))   {|inv| inv.item.code } 
            column(I18n.t('activerecord.attributes.inventory.location')) {|inv| inv.location.display_name } 
            column(I18n.t('activerecord.attributes.inventory.amount'))   {|inv| number_to_currency inv.quantity_of_surplus*inv.average_price } 
            column(I18n.t('activerecord.attributes.inventory.duration')) {|inv| distance_of_time_in_words_to_now inv.updated_at } 
          end            
        end        
      end
      column do 
      end
    end

    columns do
      column do
        panel "ActiveAdmin Demo" do
          div do
            render('/admin/sidebar_links', :model => 'dashboards')
          end

          div do
            br
            text_node %{<iframe src="https://rpm.newrelic.com/public/charts/6VooNO2hKWB" width="500" height="300" scrolling="no" frameborder="no"></iframe>}.html_safe
          end
        end
      end
    end #columns

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
