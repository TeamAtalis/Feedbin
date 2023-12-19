class ContentFormatter

  require 'nokogiri'
  require 'open-uri'

  ALLOWLIST_BASE = {}.tap do |hash|
    # hash[:elements] = %w[
    #   h1 h2 h3 h4 h5 h6 h7 h8 br b i strong em a pre code img tt div ins del sup sub
    #   p ol ul table thead tbody tfoot blockquote dl dt dd kbd q samp var hr ruby rt
    #   rp li tr td th s strike summary details figure figcaption audio video source
    #   small iframe
    # ]
    hash[:elements] = %w[
      h1 h2 h3 h4 h5 h6 h7 h8 br b i strong em a pre code tt div ins del sup sub
      p ol ul table thead tbody tfoot blockquote dl dt dd kbd q samp var hr ruby rt
      rp li tr td th s strike summary details audio video source
      small iframe
    ]

    hash[:attributes] = {
      "a" => ["href"],
      "img" => ["src", "longdesc"],
      "div" => ["itemscope", "itemtype"],
      "blockquote" => ["cite"],
      "del" => ["cite"],
      "ins" => ["cite"],
      "q" => ["cite"],
      "source" => ["src"],
      "video" => ["src", "poster", "playsinline", "loop", "muted", "controls", "preload"],
      "audio" => ["src"],
      "td" => ["align"],
      "th" => ["align"],
      "iframe" => ["src", "width", "height"],
      :all => %w[
        abbr accept accept-charset accesskey action alt axis border cellpadding
        cellspacing char charoff charset checked clear cols colspan color compact
        coords datetime dir disabled enctype for frame headers height hreflang hspace
        ismap label lang maxlength media method multiple name nohref noshade nowrap
        open prompt readonly rel rev rows rowspan rules scope selected shape size span
        start summary tabindex target title type usemap valign value vspace width
        itemprop id
      ]
    }

    hash[:protocols] = {
      "a" => {
        "href" => ["http", "https", "mailto", :relative]
      },
      "blockquote" => {
        "cite" => ["http", "https", :relative]
      },
      "del" => {
        "cite" => ["http", "https", :relative]
      },
      "ins" => {
        "cite" => ["http", "https", :relative]
      },
      "q" => {
        "cite" => ["http", "https", :relative]
      },
      "img" => {
        "src" => ["http", "https", :relative, "data"],
        "longdesc" => ["http", "https", :relative]
      },
      "video" => {
        "src" => ["http", "https"],
        "poster" => ["http", "https"]
      },
      "audio" => {
        "src" => ["http", "https"]
      }
    }

    hash[:remove_contents] = %w[script style iframe object embed]
  end

  ALLOWLIST_DEFAULT = ALLOWLIST_BASE.clone.tap do |hash|
    transformers = Transformers.new
    hash[:transformers] = [transformers.class_allowlist, transformers.table_elements, transformers.video, transformers.top_level_li , transformers.remove_empty_elements, transformers.links]
  end

  ALLOWLIST_NEWSLETTER = ALLOWLIST_BASE.clone.tap do |hash|
    hash[:elements] = hash[:elements] - %w[table thead tbody tfoot tr td]
  end

  ALLOWLIST_EVERNOTE = {
    elements: %w[
      a abbr acronym address area b bdo big blockquote br caption center cite code col colgroup dd
      del dfn div dl dt em font h1 h2 h3 h4 h5 h6 hr i img ins kbd li map ol p pre q s samp small
      strike strong sub sup table tbody td tfoot th thead tr tt u ul var xmp
    ],
    remove_contents: ["script", "style", "iframe", "object", "embed", "title"],
    attributes: {
        "a"     => ["href"],
        "img"   => ["src", "width", "height", "alt"],
        "ol"    => Sanitize::Config::RELAXED[:attributes]["ol"],
        "ul"    => Sanitize::Config::RELAXED[:attributes]["ul"],
        "table" => Sanitize::Config::RELAXED[:attributes]["table"],
        "td"    => Sanitize::Config::RELAXED[:attributes]["td"],
        "th"    => Sanitize::Config::RELAXED[:attributes]["th"]
    },
    protocols: {
      "a" => {"href" => ["http", "https", :relative]},
      "img" => {"src" => ["http", "https", :relative]}
    }
  }

  SANITIZE_BASIC = Sanitize::Config.merge(Sanitize::Config::BASIC,
    remove_contents: ["script", "style", "iframe", "object", "embed", "figure", "figcaption", "title"],
  )


  def self.format!(*args)
    new._format!(*args)
  end

  def _format!(content, entry = nil, image_proxy_enabled = true, base_url = nil)
    context = {
      whitelist: ALLOWLIST_DEFAULT,
      embed_url: Rails.application.routes.url_helpers.iframe_embeds_path,
      embed_classes: "iframe-placeholder entry-callout system-content"
    }
    filters = [HTML::Pipeline::SmileyFilter, HTML::Pipeline::SanitizationFilter, HTML::Pipeline::SrcFixer, HTML::Pipeline::IframeFilter]

    if ENV["CAMO_HOST"] && ENV["CAMO_KEY"] && image_proxy_enabled
      context[:asset_proxy] = ENV["CAMO_HOST"]
      context[:asset_proxy_secret_key] = ENV["CAMO_KEY"]
      context[:asset_src_attribute] = "data-camo-src"
      filters = filters << HTML::Pipeline::CamoFilter
    end

    if entry || base_url
      filters.unshift(HTML::Pipeline::AbsoluteSourceFilter)
      filters.unshift(HTML::Pipeline::AbsoluteHrefFilter)

      context[:image_base_url]    = base_url || entry.base_url
      context[:image_subpage_url] = base_url || entry.fully_qualified_url || ""
      context[:href_base_url]     = base_url || entry.base_url
      context[:href_subpage_url]  = base_url || entry.fully_qualified_url || ""

      if entry && entry.feed.newsletter?
        context[:whitelist] = ALLOWLIST_NEWSLETTER
      end
    end

    filters.unshift(HTML::Pipeline::LazyLoadFilter)

    pipeline = HTML::Pipeline.new filters, context

    result = pipeline.call(content)

    if entry&.archived_images?
      result[:output] = ImageFallback.new(result[:output]).add_fallbacks
    end

    result[:output].to_s
  end

  def self.newsletter_format(*args)
    new._newsletter_format(*args)
  end

  def _newsletter_format(content)
    context = {
      whitelist: Sanitize::Config::RELAXED
    }
    filters = [HTML::Pipeline::SanitizationFilter]

    if ENV["CAMO_HOST"] && ENV["CAMO_KEY"]
      context[:asset_proxy] = ENV["CAMO_HOST"]
      context[:asset_proxy_secret_key] = ENV["CAMO_KEY"]
      context[:asset_src_attribute] = "data-camo-src"
      filters = filters << HTML::Pipeline::CamoFilter
    end

    pipeline = HTML::Pipeline.new filters, context

    result = pipeline.call(content)

    result[:output].to_s
  end

  def self.absolute_source(*args)
    new._absolute_source(*args)
  end

  def _absolute_source(content, entry, base_url = nil)
    filters = [HTML::Pipeline::AbsoluteSourceFilter, HTML::Pipeline::AbsoluteHrefFilter]
    context = {
      image_base_url:    base_url || entry.base_url,
      image_subpage_url: base_url || entry.fully_qualified_url || "",
      href_base_url:     base_url || entry.base_url,
      href_subpage_url:  base_url || entry.fully_qualified_url || ""
    }
    pipeline = HTML::Pipeline.new filters, context
    result = pipeline.call(content)
    result[:output].to_s
  rescue
    content
  end

  def self.api_format(*args)
    new._api_format(*args)
  end

  def _api_format(content, entry)
    filters = [HTML::Pipeline::AbsoluteSourceFilter, HTML::Pipeline::AbsoluteHrefFilter, HTML::Pipeline::ProtocolFilter, HTML::Pipeline::SanitizationFilter]
    context = {
      image_base_url: entry.base_url,
      image_subpage_url: entry.fully_qualified_url || "",
      href_base_url: entry.base_url,
      href_subpage_url: entry.fully_qualified_url || ""
    }
    context[:whitelist] = ALLOWLIST_DEFAULT
    if entry.feed.newsletter?
      context[:whitelist] = ALLOWLIST_NEWSLETTER
    end
    pipeline = HTML::Pipeline.new filters, context
    result = pipeline.call(content)
    result[:output].to_s
  rescue
    content
  end

  def self.app_format(*args)
    new._app_format(*args)
  end

  def _app_format(content, entry)
    filters = [HTML::Pipeline::AbsoluteSourceFilter, HTML::Pipeline::AbsoluteHrefFilter, HTML::Pipeline::ProtocolFilter, HTML::Pipeline::ImagePlaceholderFilter]
    context = {
      image_base_url: entry.base_url,
      image_subpage_url: entry.fully_qualified_url || "",
      href_base_url: entry.base_url,
      href_subpage_url: entry.fully_qualified_url || "",
      placeholder_url: "",
      placeholder_attribute: "data-feedbin-src"
    }
    pipeline = HTML::Pipeline.new filters, context
    result = pipeline.call(content)
    result[:output].to_s
  rescue
    content
  end

  def self.evernote_format(*args)
    new._evernote_format(*args)
  end

  def _evernote_format(content, entry)
    filters = [HTML::Pipeline::SanitizationFilter, HTML::Pipeline::SrcFixer, HTML::Pipeline::AbsoluteSourceFilter, HTML::Pipeline::AbsoluteHrefFilter, HTML::Pipeline::ProtocolFilter]
    context = {
      whitelist: ALLOWLIST_EVERNOTE,
      image_base_url: entry.base_url,
      image_subpage_url: entry.fully_qualified_url || "",
      href_base_url: entry.base_url,
      href_subpage_url: entry.fully_qualified_url || ""
    }

    pipeline = HTML::Pipeline.new filters, context
    result = pipeline.call(content)
    result[:output].to_xml
  rescue
    content
  end

  def self.summary(*args)
    new._summary(*args)
  end

  def _summary(text, length = nil)
    text = Loofah.fragment(text)
      .scrub!(:prune)
      .to_text(encode_special_chars: false)
      .gsub(/\s+/, " ")
      .squish

    text = text.truncate(length, separator: " ", omission: "") if length

    text
  end

  def self.text_email(*args)
    new._text_email(*args)
  end

  def _text_email(content)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(hard_wrap: true), autolink: true)
    content = markdown.render(content)
    Sanitize.fragment(content, ALLOWLIST_DEFAULT).html_safe
  rescue
    content
  end

  def self.remove_duplicates(*args)
    new._remove_duplicates(*args)
  end

  def _remove_duplicates(content, old_content = nil)
    document = Nokogiri::HTML.fragment(content)
      seen_nodes = Set.new  
      document.traverse do |node| 
        node_key = "#{node.name}-#{node.content}"      
        node.remove if seen_nodes.include?(node_key)       
        seen_nodes.add(node_key)
      end  
      document.to_html
  rescue
    content
  end

  def self.get_content(*args)
    new._get_content(*args)
  end

  def _get_content(url, entry_title = "")
      content = ""
      html = Nokogiri::HTML(URI.open(url))
          
      h1 = html.at('h1')
          
      if h1 && !h1.text.include?(entry_title)
        content += h1.to_html.encode("UTF-8")
      end
          
      # following_elements = h1&.xpath('./following::*[not(self::figure or self::img or self::figcaption or self::picture or self::button) and not (ancestor::figure or ancestor::img or ancestor::figcaption or ancestor::picture or ancestor::button)]')

      following_elements = h1&.xpath('./following::article')

      if !following_elements&.any?
        following_elements = h1&.xpath('./following::*')
        following_elements = following_elements.uniq { |node| node.name.downcase }
        following_elements = following_elements.uniq { |node| node.content.downcase }
      end

      content += following_elements.map(&:to_html).join('').encode("UTF-8")

      content
  end
end
