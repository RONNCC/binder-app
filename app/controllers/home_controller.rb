class HomeController < ApplicationController
  def index
  end

  def milestones
  end

  def search
    authorize! :search, nil

    if params.blank? or params[:query].blank?
      flash[:error] = "Please enter a query"
      redirect_to root_url
      return
    end

    @query = params[:query]

    @tool_lookup = Tool.find_by_barcode(@query)
    unless @tool_lookup.nil?
      redirect_to @tool_lookup
      return
    end

    @tool_lookup = Tool.search(@query).to_a
    @tool_lookup = Tool.search(@query.singularize).to_a if @tool_lookup.empty?
    unless @tool_lookup.nil? || @tool_lookup.empty?
      if @tool_lookup.size > 1
        redirect_to tools_path(type_filter: @tool_lookup[0].tool_type.id)
      elsif @tool_lookup.size == 1
        redirect_to @tool_lookup[0]
      end
      return
    end

    @org = Organization.where('lower(name) = lower(?) OR lower(short_name) = lower(?)', @query, @query).first
    org_alias = OrganizationAlias.where('lower(name) = lower(?)', @query).first unless !@org.blank?
    @org = org_alias.organization unless org_alias.blank?

    unless @org.blank?
      redirect_to @org
      return
    end

    @participant_lookup = Participant.find_by_card(@query, true)
    unless @participant_lookup.nil?
      if @participant_lookup.organizations.blank? and can?(:create, Membership)
        redirect_to new_participant_membership_path(@participant_lookup)
        return
      else
        redirect_to @participant_lookup
        return
      end
    end

    @faqs = Faq.search(@query) if can?(:read, Faq)
    @participants = Participant.search(@query)
    @tools = Tool.search(@query)
    @organizations = Organization.search(@query)
    @organization_aliases = OrganizationAlias.search(@query)
    @documents = Document.search(@query)

    @new_participant = Participant.search_ldap(@query)
  end

  def dev_login
    unless Rails.env.production?
      email = case params[:role]
        when 'Admin' then 'rcrown@andrew.cmu.edu'
        when 'SCC Member' then 'cbrownel@andrew.cmu.edu'
        when 'Booth Chair' then 'rpwhite@andrew.cmu.edu'
        when 'Participant' then 'nharper@andrew.cmu.edu'
      end

      sign_in(:user, User.find_by_email(email))

      session[:name] = params[:role]
    end

    redirect_to root_url
  end

  def hardhats
    @organizations = Organization.joins(:tools).distinct
    @total = Tool.hardhats.checked_out.count
  end

  def charge_overview
    @organizations = Organization.joins(:charges).distinct.includes(:charges)
    @charge_types = ChargeType.all.includes(:charges)
    @approved_total = Charge.approved.sum('amount')
    @pending_total = Charge.pending.sum('amount')
    @total = Charge.all.sum('amount')
  end

  def downtime
    @organizations = Organization.only_categories(['Fraternity', 'Sorority', 'Independent', 'Blitz', 'Concessions'])
  end

  def hardhat_return
  end
end
