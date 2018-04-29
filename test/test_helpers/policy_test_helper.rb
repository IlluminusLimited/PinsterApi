# frozen_string_literal: true

module PolicyTestHelper
  ANY_ACTION = %i[index? show? new? create? update? destroy?].freeze
  ANY_VIEW_ACTION = %i[index? show?].freeze
  ANY_CREATE_ACTION = %i[new? create?].freeze
  ANY_INSTANCE_ACTION = %i[show? update? destroy?].freeze
  ANY_INSTANCE_ALTER_ACTION = %i[update? destroy?].freeze
end
