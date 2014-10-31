module PseudoRelationship
  def default_scope
    #TECHDEBT handle false values too
    where(pseudo: nil)
  end

  def pseudo
    with_pseudo.where(pseudo: true)
  end

  def with_pseudo
    all.tap { |x| x.default_scoped = false }
  end
end
