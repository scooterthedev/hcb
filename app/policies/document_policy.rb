# frozen_string_literal: true

class DocumentPolicy < ApplicationPolicy
  def common_index?
    user.auditor?
  end

  def index?
    return true if user.auditor?
    return true if record.blank?

    event_ids = record.map(&:event).pluck(:id)
    same_event = event_ids.uniq.size == 1
    return true if same_event && user.events.pluck(:id).include?(event_ids.first)
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def show?
    user.auditor?
  end

  def edit?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def download?
    user.auditor? || record.event.nil? || record.event.users.include?(user)
  end

  def fiscal_sponsorship_letter?
    !(record&.unapproved? || record&.pending?) && !record.demo_mode? && (record.users.include?(user) || user.auditor?)
  end

  def verification_letter?
    !(record&.unapproved? || record&.pending?) && !record.demo_mode? && (record.users.include?(user) || user.auditor?) && record.account_number.present?
  end

  def toggle_archive?
    user.admin?
  end

end
